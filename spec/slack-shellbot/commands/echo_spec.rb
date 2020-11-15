require 'spec_helper'

describe SlackShellbot::Commands::Echo do
  let(:team) { Fabricate(:team) }
  let(:app) { SlackShellbot::Server.new(team: team) }
  let(:client) { app.send(:client) }
  let(:message_hook) { SlackRubyBot::Hooks::Message.new }
  context 'echo' do
    it 'no message' do
      expect(client).to receive(:say).with(channel: 'channel', text: "\n")
      message_hook.call(client, Hashie::Mash.new(team: team, text: "echo", channel: 'channel'))
    end
    it 'message' do
      expect(client).to receive(:say).with(channel: 'channel', text: 'hi')
      message_hook.call(client, Hashie::Mash.new(team: team, text: "echo hi", channel: 'channel'))
    end
    it 'pipe into a file' do
      expect do
        expect(client.web_client).to receive(:chat_postMessage).with(channel: 'channel', text: '```hi```', as_user: true)
        expect(client.web_client).to receive(:chat_postMessage).with(channel: 'channel', text: '```2 byte(s) written```', as_user: true)
        message_hook.call(client, Hashie::Mash.new(team: team, text: "echo hi > \"text file.txt\"", channel: 'channel'))
      end.to change(FileEntry, :count).by(1)
      root = team.fs['channel'].root_directory_entry
      expect(root.entries.count).to eq 1
      file = root.entries.first
      expect(file).to be_a FileEntry
      expect(file.name).to eq 'text file.txt'
    end
  end
end
