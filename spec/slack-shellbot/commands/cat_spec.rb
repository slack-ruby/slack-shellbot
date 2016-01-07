require 'spec_helper'

describe SlackShellbot::Commands::Cat do
  let(:team) { Fabricate(:team) }
  let(:app) { SlackShellbot::Server.new(team: team) }
  let(:client) { app.send(:client) }
  context 'echo' do
    let!(:fs) { team.fs['channel'] }
    let!(:file) { Fabricate(:file_entry, data: 'hello world', parent_directory_entry: fs.root_directory_entry) }
    it 'pipe into a file' do
      expect(message: "#{SlackRubyBot.config.user} cat #{file.name}", channel: 'channel').to respond_with_slack_message(
        '```hello world```'
      )
    end
  end
end
