require 'spec_helper'

describe SlackShellbot::Commands::Pwd do
  let(:team) { Fabricate(:team) }
  let(:app) { SlackShellbot::Server.new(team: team) }
  let(:client) { app.send(:client) }
  let(:message_hook) { SlackRubyBot::Hooks::Message.new }
  context 'pwd' do
    it 'returns current directory' do
      expect(client).to receive(:say).with(channel: 'channel', text: '/')
      message_hook.call(client, Hashie::Mash.new(team: team, text: "pwd", channel: 'channel'))
    end
  end
end
