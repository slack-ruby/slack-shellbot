require 'spec_helper'

describe SlackShellbot::Commands::Whoami do
  let(:team) { Fabricate(:team) }
  let(:app) { SlackShellbot::Server.new(team: team) }
  let(:client) { app.send(:client) }
  context 'whoami' do
    it 'returns username' do
      expect(client).to receive(:say).with(channel: 'channel', text: '<@user>')
      app.send(:message, client, text: "#{SlackRubyBot.config.user} whoami", channel: 'channel', user: 'user')
    end
  end
end
