require 'spec_helper'

describe SlackShellbot::Commands::Vi do
  let(:team) { Fabricate(:team) }
  let(:app) { SlackShellbot::Server.new(team: team) }
  let!(:fs) { team.fs['channel'] }
  context 'vi' do
    it 'creates a file' do
      expect do
        expect(message: "#{SlackRubyBot.config.user} vi test.txt", channel: 'channel').to respond_with_slack_message(
          "```~|\n\n\n\"/test.txt\" [New File]```"
        )
      end.to change(Program, :count).by(1)
      expect(fs.reload.program).to be_a ViProgram
    end
    context 'existing file' do
      let!(:file) { Fabricate(:file_entry, name: 'name.txt', data: 'hello world', parent_directory_entry: fs.root_directory_entry) }
      it 'opens an existing file' do
        expect do
          expect(message: "#{SlackRubyBot.config.user} vi \"#{file.name}\"", channel: 'channel').to respond_with_slack_message(
            "```hello world\n~|\n\n\n\"/name.txt\" 1 line(s), 11 character(s)```"
          )
        end.to change(Program, :count).by(1)
        expect(fs.reload.program).to be_a ViProgram
      end
    end
    context 'opened file' do
      let!(:file) { Fabricate(:file_entry, name: 'name.txt', data: 'hello world', parent_directory_entry: fs.root_directory_entry) }
      let!(:vi) { Fabricate(:vi_program, file_system: fs, filename: file.name) }
      it 'appends to the file' do
        expect(message: "#{SlackRubyBot.config.user} another line", channel: 'channel').to respond_with_slack_message(
          "```\hello world\nanother line\n~|\n\n\n\"/name.txt\" 2 line(s), 24 character(s)```"
        )
        expect(vi.reload.data).to eq ['hello world', 'another line'].join("\n")
        expect(file.reload.data).to eq ['hello world'].join("\n")
      end
      it 'saves file' do
        expect(message: "#{SlackRubyBot.config.user} another line", channel: 'channel').to respond_with_slack_message(
          "```\hello world\nanother line\n~|\n\n\n\"/name.txt\" 2 line(s), 24 character(s)```"
        )
        expect(message: "#{SlackRubyBot.config.user} :wq", channel: 'channel').to respond_with_slack_message(
          '```written /name.txt, 2 line(s), 24 character(s)```'
        )
        expect(file.reload.data).to eq ['hello world', 'another line'].join("\n")
      end
    end
  end
end
