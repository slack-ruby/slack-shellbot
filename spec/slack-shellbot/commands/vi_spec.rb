require 'spec_helper'

describe SlackShellbot::Commands::Vi do
  let(:team) { Fabricate(:team) }
  let(:app) { SlackShellbot::Server.new(team: team) }
  let(:client) { app.send(:client) }
  let!(:fs) { team.fs['channel'] }
  context 'vi' do
    it 'creates a file' do
      expect do
        expect(client).to receive(:say).with(channel: 'channel', text: "~|\n\n\n\"/test.txt\" [New File]")
        app.send(:message, client, text: "#{SlackRubyBot.config.user} vi test.txt", channel: 'channel')
      end.to change(Program, :count).by(1)
      expect(fs.reload.program).to be_a ViProgram
    end
    context 'existing file' do
      let!(:file) { Fabricate(:file_entry, name: 'name.txt', data: 'hello world', parent_directory_entry: fs.root_directory_entry) }
      it 'opens an existing file' do
        expect do
          expect(client).to receive(:say).with(channel: 'channel', text: "hello world\n~|\n\n\n\"/name.txt\" 1 line(s), 11 character(s)")
          app.send(:message, client, text: "#{SlackRubyBot.config.user} vi \"#{file.name}\"", channel: 'channel')
        end.to change(Program, :count).by(1)
        expect(fs.reload.program).to be_a ViProgram
      end
    end
    context 'opened file' do
      let!(:file) { Fabricate(:file_entry, name: 'name.txt', data: 'hello world', parent_directory_entry: fs.root_directory_entry) }
      let!(:vi) { Fabricate(:vi_program, file_system: fs, filename: file.name) }
      it 'appends to the file' do
        expect(client).to receive(:say).with(channel: 'channel', text: "\hello world\nanother line\n~|\n\n\n\"/name.txt\" 2 line(s), 24 character(s)")
        app.send(:message, client, text: "#{SlackRubyBot.config.user} another line", channel: 'channel')
        expect(vi.reload.data).to eq ['hello world', 'another line'].join("\n")
        expect(file.reload.data).to eq ['hello world'].join("\n")
      end
      it 'saves file' do
        expect(client).to receive(:say).with(channel: 'channel', text: "\hello world\nanother line\n~|\n\n\n\"/name.txt\" 2 line(s), 24 character(s)")
        app.send(:message, client, text: "#{SlackRubyBot.config.user} another line", channel: 'channel')
        expect(client).to receive(:say).with(channel: 'channel', text: 'written /name.txt, 2 line(s), 24 character(s)')
        app.send(:message, client, text: "#{SlackRubyBot.config.user} :wq", channel: 'channel')
        expect(file.reload.data).to eq ['hello world', 'another line'].join("\n")
      end
    end
  end
end
