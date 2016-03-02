require 'spec_helper'

describe SlackShellbot::Commands::Pwd do
  let(:team) { Fabricate(:team) }
  let(:app) { SlackShellbot::Server.new(team: team) }
  let(:client) { app.send(:client) }
  context 'ls' do
    it 'returns contents of the current directory' do
      expect(client).to receive(:say).with(channel: 'channel', text: ".\n..")
      app.send(:message, client, text: "#{SlackRubyBot.config.user} ls", channel: 'channel')
    end
  end
end
