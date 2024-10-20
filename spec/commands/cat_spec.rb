require 'spec_helper'

describe SlackShellbot::Commands::Cat do
  let(:team) { Fabricate(:team) }
  let(:client) { SlackShellbot::Web::Client.new(token: 'token', team: team) }
  let(:message_hook) { SlackShellbot::Commands::Base }

  context 'echo' do
    let!(:fs) { team.fs['channel'] }
    let!(:file) { Fabricate(:file_entry, data: 'hello world', parent_directory_entry: fs.root_directory_entry) }

    it 'pipe into a file' do
      expect(client).to receive(:say).with(channel: 'channel', text: 'hello world')
      message_hook.call(client, Hashie::Mash.new(text: "cat #{file.name}", channel: 'channel', team: team))
    end

    it 'provides syntax' do
      expect(client).to receive(:say).with(channel: 'channel', text: 'usage: cat <file> ...')
      message_hook.call(client, Hashie::Mash.new(text: "cat", channel: 'channel', team: team))
    end
  end
end
