require 'spec_helper'

describe SlackRubyBotServer::Api::Middleware do
  include Rack::Test::Methods

  let(:app) { described_class.instance }

  it 'returns a structured error for an unsupported request method' do
    post '/api'

    expect(last_response.status).to eq 400
    expect(JSON.parse(last_response.body)).to include('type' => 'other_error', 'message' => '405 Not Allowed')
  end

  describe 'website asset caching' do
    ['/', '/help.html', '/privacy.html'].each do |path|
      it "serves #{path} with versioned local assets and a revalidating cache policy" do
        get path

        assets = Capybara.string(last_response.body).all('script[src^="/"], link[href^="/"], img[src^="/"]', visible: :all)
        expect(assets).not_to be_empty
        expect(assets.map { |asset| asset[:src] || asset[:href] }).to all(match(/\?v=[a-f0-9]{64}\z/))
        expect(last_response.headers['Cache-Control']).to eq 'private, no-cache'
      end
    end

    it 'renders a revalidating stylesheet with a versioned background image' do
      get '/styles.css'

      expect(last_response.content_type).to eq 'text/css; charset=utf-8'
      expect(last_response.headers['Cache-Control']).to eq 'private, no-cache'
      expect(last_response.body).to include("/img/screenshot-background.svg?v=#{Digest::SHA256.file('public/img/screenshot-background.svg').hexdigest}")
    end

    it 'revalidates static assets using their content ETag' do
      get '/scripts/shell.js'
      etag = last_response.headers['ETag']
      expect(etag).to eq %("#{Digest::SHA256.file('public/scripts/shell.js').hexdigest}")

      get '/scripts/shell.js', {}, 'HTTP_IF_NONE_MATCH' => etag
      expect(last_response.status).to eq 304
      expect(last_response.body).to be_empty
    end

    it 'returns the asset for an old ETag even when its timestamp matches' do
      get '/scripts/shell.js', {}, 'HTTP_IF_NONE_MATCH' => '"old-content"',
                                   'HTTP_IF_MODIFIED_SINCE' => File.mtime('public/scripts/shell.js').httpdate

      expect(last_response.status).to eq 200
      expect(last_response.body).to eq File.read('public/scripts/shell.js')
    end
  end

  context 'when a health check fails' do
    let(:team) { Fabricate(:team) }
    let(:slack_client) { instance_double(Slack::Web::Client) }

    before do
      allow(Slack::Web::Client).to receive(:new).with(token: team.token).and_return(slack_client)
      allow(slack_client).to receive(:auth_test).and_raise(StandardError, 'Slack ping failed')
    end

    it 'preserves the original failure in the error response' do
      get '/api/status'

      expect(last_response.status).to eq 400
      expect(JSON.parse(last_response.body)).to include('type' => 'other_error', 'message' => 'Slack ping failed')
    end

    it 'deactivates revoked installations and returns an explicit failed ping' do
      allow(slack_client).to receive(:auth_test).and_raise(Slack::Web::Api::Errors::SlackError, 'account_inactive')
      get '/api/status'

      expect(last_response.status).to eq 200
      expect(JSON.parse(last_response.body)).to include(
        'ping' => { 'ok' => false, 'error' => 'account_inactive' },
        'active_teams_count' => 0
      )
      expect(team.reload.active).to be false
    end
  end
end
