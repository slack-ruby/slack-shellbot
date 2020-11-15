require 'spec_helper'

describe SlackShellbot::Commands::Touch do
  let(:team) { Fabricate(:team) }
  let(:app) { SlackShellbot::Server.new(team: team) }
  let(:client) { app.send(:client) }
  let(:message_hook) { SlackRubyBot::Hooks::Message.new }
  context 'touch' do
    it 'returns new file name' do
      expect(client).to receive(:say).with(channel: 'channel', text: '/test.txt')
      message_hook.call(client, Hashie::Mash.new(team: team, text: "touch test.txt", channel: 'channel'))
    end
  end
end
