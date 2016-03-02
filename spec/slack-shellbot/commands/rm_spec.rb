require 'spec_helper'

describe SlackShellbot::Commands::Rm do
  let(:team) { Fabricate(:team) }
  let(:app) { SlackShellbot::Server.new(team: team) }
  let(:client) { app.send(:client) }
  context 'rm' do
    let!(:fs) { team.fs['channel'] }
    context 'a file' do
      let!(:file) { Fabricate(:file_entry, name: 'test.txt', parent_directory_entry: fs.root_directory_entry) }
      it 'returns removed file name' do
        expect do
          expect(client).to receive(:say).with(channel: 'channel', text: '/test.txt')
          app.send(:message, client, text: "#{SlackRubyBot.config.user} rm test.txt", channel: 'channel')
        end.to change(FileEntry, :count).by(-1)
      end
    end
    context 'a file with a >' do
      let!(:file) { Fabricate(:file_entry, name: '> test.txt', parent_directory_entry: fs.root_directory_entry) }
      it 'returns removed file name' do
        expect do
          expect(client).to receive(:say).with(channel: 'channel', text: '/> test.txt')
          app.send(:message, client, text: "#{SlackRubyBot.config.user} rm \"> test.txt\"", channel: 'channel')
        end.to change(FileEntry, :count).by(-1)
      end
    end
  end
end
