require 'spec_helper'

describe SlackShellbot::Commands::Pwd do
  let(:team) { Fabricate(:team) }
  let(:client) { SlackShellbot::Web::Client.new(token: 'token', team: team) }
  let(:message_hook) { SlackShellbot::Commands::Base }
  context 'ls' do
    it 'returns contents of the current directory' do
      expect(client).to receive(:say).with(channel: 'channel', text: ".\n..")
      message_hook.call(client, Hashie::Mash.new(team: team, text: "ls", channel: 'channel'))
    end
  end
end
