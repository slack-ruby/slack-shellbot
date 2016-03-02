require 'spec_helper'

describe SlackShellbot::Commands::Mkdir do
  let(:team) { Fabricate(:team) }
  let(:app) { SlackShellbot::Server.new(team: team) }
  let(:client) { app.send(:client) }
  context 'mkdir' do
    it 'returns current directory' do
      expect(client).to receive(:say).with(channel: 'channel', text: '/test')
      app.send(:message, client, text: "#{SlackRubyBot.config.user} mkdir test", channel: 'channel')
    end
    it 'makes a directory with a space' do
      expect(client).to receive(:say).with(channel: 'channel', text: '/foo bar')
      app.send(:message, client, text: "#{SlackRubyBot.config.user} mkdir \"foo bar\"", channel: 'channel')
    end
  end
end
