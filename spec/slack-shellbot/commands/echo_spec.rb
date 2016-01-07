require 'spec_helper'

describe SlackShellbot::Commands::Echo do
  let(:team) { Fabricate(:team) }
  let(:app) { SlackShellbot::Server.new(team: team) }
  let(:client) { app.send(:client) }
  context 'echo' do
    it 'no message' do
      expect(message: "#{SlackRubyBot.config.user} echo", channel: 'channel').to respond_with_slack_message(
        "```\n```"
      )
    end
    it 'message' do
      expect(message: "#{SlackRubyBot.config.user} echo hi", channel: 'channel').to respond_with_slack_message(
        '```hi```'
      )
    end
    it 'pipe into a file' do
      expect do
        allow(SlackRubyBot::Commands::Base).to receive(:send_client_message).with(client, channel: 'channel', text: '```hi```')
        expect(message: "#{SlackRubyBot.config.user} echo hi > text.txt", channel: 'channel').to respond_with_slack_message(
          '```2 byte(s) written```'
        )
      end.to change(FileEntry, :count).by(1)
      root = team.fs['channel'].root_directory_entry
      expect(root.entries.count).to eq 1
      file = root.entries.first
      expect(file).to be_a FileEntry
    end
  end
end
