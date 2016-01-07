require 'spec_helper'

describe SlackShellbot::Commands::Pwd do
  let(:team) { Fabricate(:team) }
  let(:app) { SlackShellbot::Server.new(team: team) }
  context 'ls' do
    it 'returns contents of the current directory' do
      expect(message: "#{SlackRubyBot.config.user} ls", channel: 'channel').to respond_with_slack_message(
        "```.\n..```"
      )
    end
  end
end
