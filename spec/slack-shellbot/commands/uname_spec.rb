require 'spec_helper'

describe SlackShellbot::Commands::Uname do
  let(:team) { Fabricate(:team) }
  let(:app) { SlackShellbot::Server.new(team: team) }
  let(:client) { app.send(:client) }
  context 'uname' do
    it 'returns Shell' do
      expect(client).to receive(:say).with(channel: 'channel', text: 'Shell')
      app.send(:message, client, text: "#{SlackRubyBot.config.user} uname", channel: 'channel')
    end
  end
end
