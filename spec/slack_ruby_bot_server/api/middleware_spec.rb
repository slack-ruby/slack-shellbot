require 'spec_helper'

describe SlackRubyBotServer::Api::Middleware do
  include Rack::Test::Methods

  let(:app) { described_class.instance }

  it 'returns a structured error for an unsupported request method' do
    post '/api'

    expect(last_response.status).to eq 400
    expect(JSON.parse(last_response.body)).to include('type' => 'other_error', 'message' => '405 Not Allowed')
  end

  context 'when a health check fails' do
    let(:team) { Fabricate(:team) }

    before do
      allow(Team).to receive(:asc).with(:_id).and_return([team])
      allow(team).to receive(:ping!).and_raise(StandardError, 'Slack ping failed')
    end

    it 'preserves the original failure in the error response' do
      get '/api/status'

      expect(last_response.status).to eq 400
      expect(JSON.parse(last_response.body)).to include('type' => 'other_error', 'message' => 'Slack ping failed')
    end
  end
end
