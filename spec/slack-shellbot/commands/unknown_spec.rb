require 'spec_helper'

describe SlackRubyBot::Commands::Unknown, vcr: { cassette_name: 'user_info' } do
  let!(:team) { Fabricate(:team) }
  let(:app) { SlackShellbot::Server.new(team: team) }
  let(:client) { app.send(:client) }
  it 'invalid command' do
    expect(client).to receive(:say).with(channel: 'channel', text: "Sorry <@user>, I don't understand that command!", gif: 'idiot')
    app.send(:message, client, text: "#{SlackRubyBot.config.user} foobar", channel: 'channel', user: 'user')
  end
  it 'does not respond to sad face' do
    expect(SlackRubyBot::Commands::Base).to_not receive(:send_message)
    SlackShellbot::Server.new(team: team).send(:message, client, text: ':((')
  end
end
