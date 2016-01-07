require 'spec_helper'

describe SlackShellbot::Commands::Pwd do
  let(:team) { Fabricate(:team) }
  let(:app) { SlackShellbot::Server.new(team: team) }
  context 'pwd' do
    it 'returns current directory' do
      expect(message: "#{SlackRubyBot.config.user} pwd", channel: 'channel').to respond_with_slack_message(
        '```/```'
      )
    end
  end
end
