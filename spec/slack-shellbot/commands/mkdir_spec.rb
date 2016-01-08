require 'spec_helper'

describe SlackShellbot::Commands::Mkdir do
  let(:team) { Fabricate(:team) }
  let(:app) { SlackShellbot::Server.new(team: team) }
  context 'mkdir' do
    it 'returns current directory' do
      expect(message: "#{SlackRubyBot.config.user} mkdir test", channel: 'channel').to respond_with_slack_message(
        '```/test```'
      )
    end
    it 'makes a directory with a space' do
      expect(message: "#{SlackRubyBot.config.user} mkdir \"foo bar\"", channel: 'channel').to respond_with_slack_message(
        '```/foo bar```'
      )
    end
  end
end
