require 'spec_helper'

describe SlackShellbot::Commands::Touch do
  let(:team) { Fabricate(:team) }
  let(:app) { SlackShellbot::Server.new(team: team) }
  let(:client) { app.send(:client) }
  context 'touch' do
    it 'returns new file name' do
      expect(client).to receive(:say).with(channel: 'channel', text: '/test.txt')
      app.send(:message, client, text: "#{SlackRubyBot.config.user} touch test.txt", channel: 'channel')
    end
  end
end
