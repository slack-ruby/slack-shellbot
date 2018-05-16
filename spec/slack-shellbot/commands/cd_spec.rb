require 'spec_helper'

describe SlackShellbot::Commands::Pwd do
  let(:team) { Fabricate(:team) }
  let(:app) { SlackShellbot::Server.new(team: team) }
  let(:client) { app.send(:client) }
  let(:message_hook) { SlackRubyBot::Hooks::Message.new }
  context 'cd' do
    it 'changes directory' do
      expect(client).to receive(:say).with(channel: 'channel', text: '/test')
      message_hook.call(client, Hashie::Mash.new(team: team, text: "#{SlackRubyBot.config.user} mkdir test", channel: 'channel'))

      expect(client).to receive(:say).with(channel: 'channel', text: '/test')
      message_hook.call(client, Hashie::Mash.new(team: team, text: "#{SlackRubyBot.config.user} cd test", channel: 'channel'))

      expect(client).to receive(:say).with(channel: 'channel', text: '/test')
      message_hook.call(client, Hashie::Mash.new(team: team, text: "#{SlackRubyBot.config.user} pwd", channel: 'channel'))
    end
  end
end
