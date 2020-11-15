require 'spec_helper'

describe SlackShellbot::Commands::Default do
  let!(:team) { Fabricate(:team) }
  let(:app) { SlackShellbot::Server.new(team: team) }
  let(:client) { app.send(:client) }
  let(:message_hook) { SlackRubyBot::Hooks::Message.new }
  it 'default' do
    expect(client).to receive(:say).with(channel: 'channel', text: SlackShellbot::INFO)
    expect(client).to receive(:_say).with(channel: 'channel')
    message_hook.call(client, Hashie::Mash.new(team: team, channel: 'channel', text: SlackRubyBot.config.user))
  end
  it 'upcase' do
    expect(client).to receive(:say).with(channel: 'channel', text: SlackShellbot::INFO)
    expect(client).to receive(:_say).with(channel: 'channel')
    message_hook.call(client, Hashie::Mash.new(team: team, channel: 'channel', text: SlackRubyBot.config.user.upcase))
  end
end
