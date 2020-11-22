require 'spec_helper'

describe SlackShellbot::Commands::Pwd do
  let(:team) { Fabricate(:team) }
  let(:client) { SlackShellbot::Web::Client.new(token: 'token', team: team) }
  let(:message_hook) { SlackShellbot::Commands::Base }
  context 'cd' do
    it 'changes directory' do
      expect(client).to receive(:say).with(channel: 'channel', text: '/test')
      message_hook.call(client, Hashie::Mash.new(team: team, text: "mkdir test", channel: 'channel'))

      expect(client).to receive(:say).with(channel: 'channel', text: '/test')
      message_hook.call(client, Hashie::Mash.new(team: team, text: "cd test", channel: 'channel'))

      expect(client).to receive(:say).with(channel: 'channel', text: '/test')
      message_hook.call(client, Hashie::Mash.new(team: team, text: "pwd", channel: 'channel'))
    end
  end
end
