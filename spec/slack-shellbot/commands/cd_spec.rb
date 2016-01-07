require 'spec_helper'

describe SlackShellbot::Commands::Pwd do
  let(:team) { Fabricate(:team) }
  let(:app) { SlackShellbot::Server.new(team: team) }
  context 'cd' do
    it 'changes directory' do
      expect(message: "#{SlackRubyBot.config.user} mkdir test", channel: 'channel').to respond_with_slack_message(
        '```/test```'
      )
      expect(message: "#{SlackRubyBot.config.user} cd test", channel: 'channel').to respond_with_slack_message(
        '```/test```'
      )
      expect(message: "#{SlackRubyBot.config.user} pwd", channel: 'channel').to respond_with_slack_message(
        '```/test```'
      )
    end
  end
end
