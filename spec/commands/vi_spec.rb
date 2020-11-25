require 'spec_helper'

describe SlackShellbot::Commands::Vi do
  let(:team) { Fabricate(:team) }
  let(:client) { SlackShellbot::Web::Client.new(token: 'token', team: team) }
  let(:message_hook) { SlackShellbot::Commands::Base }
  let!(:fs) { team.fs['channel'] }
  context 'vi' do
    it 'creates a file' do
      expect do
        expect(client).to receive(:say).with(channel: 'channel', text: "~|\n\n\n\"/test.txt\" [New File]")
        message_hook.call(client, Hashie::Mash.new(team: team, text: "vi test.txt", channel: 'channel'))
      end.to change(Program, :count).by(1)
      expect(fs.reload.program).to be_a ViProgram
    end
    context 'existing file' do
      let!(:file) { Fabricate(:file_entry, name: 'name.txt', data: 'hello world', file_system: fs, parent_directory_entry: fs.root_directory_entry) }
      it 'opens an existing file' do
        expect do
          expect(client).to receive(:say).with(channel: 'channel', text: "hello world\n~|\n\n\n\"/name.txt\" 1 line(s), 11 character(s)")
          message_hook.call(client, Hashie::Mash.new(team: team, text: "vi \"#{file.name}\"", channel: 'channel'))
        end.to change(Program, :count).by(1)
        expect(fs.reload.program).to be_a ViProgram
      end
    end
    context 'opened file' do
      let!(:file) { Fabricate(:file_entry, name: 'name.txt', data: 'hello world', file_system: fs, parent_directory_entry: fs.root_directory_entry) }
      let!(:vi) { Fabricate(:vi_program, file_system: fs, file_entry: file, filename: file.name) }
      it 'appends to the file' do
        expect(client).to receive(:say).with(channel: 'channel', text: "\hello world\nanother line\n~|\n\n\n\"/name.txt\" 2 line(s), 24 character(s)")
        message_hook.call(client, Hashie::Mash.new(team: team, text: "another line", channel: 'channel'))
        expect(vi.reload.data).to eq ['hello world', 'another line'].join("\n")
        expect(file.reload.data).to eq ['hello world'].join("\n")
      end
      it 'saves file' do
        expect(client).to receive(:say).with(channel: 'channel', text: "\hello world\nanother line\n~|\n\n\n\"/name.txt\" 2 line(s), 24 character(s)")
        message_hook.call(client, Hashie::Mash.new(team: team, text: "another line", channel: 'channel'))
        expect(client).to receive(:say).with(channel: 'channel', text: 'written /name.txt, 2 line(s), 24 character(s)')
        message_hook.call(client, Hashie::Mash.new(team: team, text: ":wq", channel: 'channel'))
        expect(file.reload.data).to eq ['hello world', 'another line'].join("\n")
      end
      it 'quits without saving file' do
        expect(client).to receive(:say).with(channel: 'channel', text: "\hello world\nanother line\n~|\n\n\n\"/name.txt\" 2 line(s), 24 character(s)")
        message_hook.call(client, Hashie::Mash.new(team: team, text: "another line", channel: 'channel'))
        expect(client).to receive(:say).with(channel: 'channel', text: 'quit without saving /name.txt')
        message_hook.call(client, Hashie::Mash.new(team: team, text: ":q", channel: 'channel'))
        expect(file.reload.data).to eq ['hello world'].join("\n")
      end
    end
  end
end
