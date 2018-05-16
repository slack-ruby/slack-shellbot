require 'spec_helper'

describe SlackRubyBot::Commands::Unknown, vcr: { cassette_name: 'user_info' } do
  let!(:team) { Fabricate(:team) }
  let(:app) { SlackShellbot::Server.new(team: team) }
  let(:client) { app.send(:client) }
  let(:message_hook) { SlackRubyBot::Hooks::Message.new }
  it 'invalid command' do
    expect(client).to receive(:say).with(channel: 'channel', text: "Sorry <@user>, I don't understand that command!", gif: 'understand')
    message_hook.call(client, Hashie::Mash.new(team: team, text: "#{SlackRubyBot.config.user} foobar", channel: 'channel', user: 'user'))
  end
  it 'does not respond to sad face' do
    expect(SlackRubyBot::Commands::Base).to_not receive(:send_message)
    message_hook.call(client, Hashie::Mash.new(text: ':(('))
  end
end
