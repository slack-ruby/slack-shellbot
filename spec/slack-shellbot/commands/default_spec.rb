require 'spec_helper'

describe SlackShellbot::Commands::Default do
  let!(:team) { Fabricate(:team) }
  let(:app) { SlackShellbot::Server.new(team: team) }
  let(:client) { app.send(:client) }
  it 'default' do
    expect(client).to receive(:say).with(channel: 'channel', text: SlackShellbot::INFO)
    expect(client).to receive(:say).with(channel: 'channel', gif: 'robot')
    app.send(:message, client, channel: 'channel', text: SlackRubyBot.config.user)
  end
  it 'upcase' do
    expect(client).to receive(:say).with(channel: 'channel', text: SlackShellbot::INFO)
    expect(client).to receive(:say).with(channel: 'channel', gif: 'robot')
    app.send(:message, client, channel: 'channel', text: SlackRubyBot.config.user.upcase)
  end
end
