require 'spec_helper'

describe SlackShellbot::Commands::Whoami do
  let(:team) { Fabricate(:team) }
  let(:client) { SlackShellbot::Web::Client.new(token: 'token', team: team) }
  let(:message_hook) { SlackShellbot::Commands::Base }
  context 'whoami' do
    it 'returns username' do
      expect(client).to receive(:say).with(channel: 'channel', text: '<@user>')
      message_hook.call(client, Hashie::Mash.new(team: team, text: "whoami", channel: 'channel', user: 'user'))
    end
  end
end
