require 'spec_helper'

describe SlackShellbot::Commands::Uname do
  let(:team) { Fabricate(:team) }
  let(:app) { SlackShellbot::Server.new(team: team) }
  let(:client) { app.send(:client) }
  let(:message_hook) { SlackRubyBot::Hooks::Message.new }
  context 'uname' do
    it 'returns Shell' do
      expect(client).to receive(:say).with(channel: 'channel', text: 'Shell')
      message_hook.call(client, text: "#{SlackRubyBot.config.user} uname", channel: 'channel')
    end
  end
end
