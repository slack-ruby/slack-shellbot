require 'spec_helper'

describe SlackShellbot::Commands::Rm do
  let(:team) { Fabricate(:team) }
  let(:app) { SlackShellbot::Server.new(team: team) }
  context 'rm' do
    let!(:fs) { team.fs['channel'] }
    context 'a file' do
      let!(:file) { Fabricate(:file_entry, name: 'test.txt', parent_directory_entry: fs.root_directory_entry) }
      it 'returns removed file name' do
        expect do
          expect(message: "#{SlackRubyBot.config.user} rm test.txt", channel: 'channel').to respond_with_slack_message(
            '```/test.txt```'
          )
        end.to change(FileEntry, :count).by(-1)
      end
    end
    context 'a file with a >' do
      let!(:file) { Fabricate(:file_entry, name: '> test.txt', parent_directory_entry: fs.root_directory_entry) }
      it 'returns removed file name' do
        expect do
          expect(message: "#{SlackRubyBot.config.user} rm \"> test.txt\"", channel: 'channel').to respond_with_slack_message(
            '```/> test.txt```'
          )
        end.to change(FileEntry, :count).by(-1)
      end
    end
  end
end
