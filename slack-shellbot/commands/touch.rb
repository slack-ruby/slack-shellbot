module SlackShellbot
  module Commands
    class Touch < SlackRubyBot::Commands::Base
      match(/^touch([\s])?(?<file>.*)$/)

      def self.call(client, data, match)
        fs = client.owner.fs[data.channel]
        file = Shellwords.split(match['file']).first if match.names.include?('file')
        raise 'usage: touch <file> ...' unless file

        file_entry = fs.current_directory_entry.touch(file)
        client.say(channel: data.channel, text: file_entry.path)
        logger.info "MKDIR: #{client.owner}, #{fs}, file=#{file_entry}, user=#{data.user}"
      end
    end
  end
end
