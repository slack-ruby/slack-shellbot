require 'spec_helper'

describe SlackShellbot::Commands::Uname do
  let(:team) { Fabricate(:team) }
  let(:client) { SlackShellbot::Web::Client.new(token: 'token', team: team) }
  let(:message_hook) { SlackShellbot::Commands::Base }

  context 'uname' do
    it 'returns Shell' do
      expect(client).to receive(:say).with(channel: 'channel', text: 'Shell')
      message_hook.call(client, Hashie::Mash.new(team: team, text: "uname", channel: 'channel'))
    end
  end
end
