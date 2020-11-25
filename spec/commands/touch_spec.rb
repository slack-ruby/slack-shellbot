require 'spec_helper'

describe SlackShellbot::Commands::Touch do
  let(:team) { Fabricate(:team) }
  let(:client) { SlackShellbot::Web::Client.new(token: 'token', team: team) }
  let(:message_hook) { SlackShellbot::Commands::Base }
  context 'touch' do
    it 'returns new file name' do
      expect(client).to receive(:say).with(channel: 'channel', text: '/test.txt')
      message_hook.call(client, Hashie::Mash.new(team: team, text: "touch test.txt", channel: 'channel'))
    end
  end
end
