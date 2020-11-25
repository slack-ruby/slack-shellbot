# frozen_string_literal: true

require 'spec_helper'

describe 'Add to Slack', js: true, type: :feature do
  before do
    ENV['SLACK_CLIENT_ID'] = 'client_id'
    ENV['SLACK_CLIENT_SECRET'] = 'client_secret'
  end
  after do
    ENV.delete 'SLACK_CLIENT_ID'
    ENV.delete 'SLACK_CLIENT_SECRET'
  end
  it 'registers a team' do
    allow_any_instance_of(Team).to receive(:ping!).and_return(ok: true)
    expect(SlackRubyBotServer::Service.instance).to receive(:start!)
    oauth_access = Slack::Messages::Message.new({ 'access_token' => 'token', 'team' => { 'id' => 'team_id', 'name' => 'team_name' } })
    allow_any_instance_of(::Slack::Web::Client).to receive(:oauth_v2_access).with(hash_including(code: 'code')).and_return(oauth_access)
    expect do
      visit '/?code=code'
      expect(page.find('#messages')).to have_content 'Team successfully registered!'
    end.to change(Team, :count).by(1)
  end
end
