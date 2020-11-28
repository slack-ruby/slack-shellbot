require 'spec_helper'

describe SlackShellbot::Commands::Man do
  let(:team) { Fabricate(:team) }
  let(:client) { SlackShellbot::Web::Client.new(token: 'token', team: team) }
  let(:message_hook) { SlackShellbot::Commands::Base }
  context 'man' do
    it 'shows help' do
      expect(client).to receive(:say).with(channel: 'channel', text: SlackShellbot::Commands::Man::HELP)
      message_hook.call(client, Hashie::Mash.new(team: team, text: "man", channel: 'channel'))
    end
  end
end
