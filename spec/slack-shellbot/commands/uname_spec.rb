require 'spec_helper'

describe SlackShellbot::Commands::Uname do
  let(:team) { Fabricate(:team) }
  let(:app) { SlackShellbot::Server.new(team: team) }
  context 'uname' do
    it 'returns Shlack' do
      expect(message: "#{SlackRubyBot.config.user} uname", channel: 'channel').to respond_with_slack_message(
        '```Shlack```'
      )
    end
  end
end
