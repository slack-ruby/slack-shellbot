require 'spec_helper'

describe SlackShellbot::Commands::Rm do
  let(:team) { Fabricate(:team) }
  let(:app) { SlackShellbot::Server.new(team: team) }
  context 'rm' do
    it 'returns removed file name' do
      expect(message: "#{SlackRubyBot.config.user} touch test.txt", channel: 'channel').to respond_with_slack_message(
        '```/test.txt```'
      )
      expect do
        expect(message: "#{SlackRubyBot.config.user} rm test.txt", channel: 'channel').to respond_with_slack_message(
          '```/test.txt```'
        )
      end.to change(FileEntry, :count).by(-1)
    end
  end
end
