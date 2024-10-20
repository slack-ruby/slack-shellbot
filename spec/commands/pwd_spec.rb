require 'spec_helper'

describe SlackShellbot::Commands::Pwd do
  let(:team) { Fabricate(:team) }
  let(:client) { SlackShellbot::Web::Client.new(token: 'token', team: team) }
  let(:message_hook) { SlackShellbot::Commands::Base }

  context 'pwd' do
    it 'returns current directory' do
      expect(client).to receive(:say).with(channel: 'channel', text: '/')
      message_hook.call(client, Hashie::Mash.new(team: team, text: "pwd", channel: 'channel'))
    end
  end
end
