require 'spec_helper'

describe SlackShellbot::Commands::Pwd do
  let(:team) { Fabricate(:team) }
  let(:app) { SlackShellbot::Server.new(team: team) }
  let(:client) { app.send(:client) }
  context 'pwd' do
    it 'returns current directory' do
      expect(client).to receive(:say).with(channel: 'channel', text: '/')
      app.send(:message, client, text: "#{SlackRubyBot.config.user} pwd", channel: 'channel')
    end
  end
end
