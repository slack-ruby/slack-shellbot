require 'spec_helper'

describe SlackShellbot::Commands::Mkdir do
  let(:team) { Fabricate(:team) }
  let(:client) { SlackShellbot::Web::Client.new(token: 'token', team: team) }
  let(:message_hook) { SlackShellbot::Commands::Base }

  context 'mkdir' do
    it 'returns current directory' do
      expect(client).to receive(:say).with(channel: 'channel', text: '/test')
      message_hook.call(client, Hashie::Mash.new(team: team, text: "mkdir test", channel: 'channel'))
    end

    it 'makes a directory with a space' do
      expect(client).to receive(:say).with(channel: 'channel', text: '/foo bar')
      message_hook.call(client, Hashie::Mash.new(team: team, text: "mkdir \"foo bar\"", channel: 'channel'))
    end
  end
end
