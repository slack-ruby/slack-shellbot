require 'spec_helper'

describe SlackShellbot::Commands::Touch do
  let(:team) { Fabricate(:team) }
  let(:app) { SlackShellbot::Server.new(team: team) }
  context 'touch' do
    it 'returns new file name' do
      expect(message: "#{SlackRubyBot.config.user} touch test.txt", channel: 'channel').to respond_with_slack_message(
        '```/test.txt```'
      )
    end
  end
end
