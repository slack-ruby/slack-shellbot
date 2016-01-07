module SlackShellbot
  module Commands
    class Touch < SlackRubyBot::Commands::Base
      def self.call(client, data, match)
        fs = client.team.fs[data.channel]
        file = match['expression'] if match.names.include?('expression')
        fail 'usage: touch <file> ...' unless file
        file_entry = fs.current_directory_entry.touch(file)
        send_message client, data.channel, file_entry.path
        logger.info "MKDIR: #{client.team}, #{fs}, file=#{file_entry}, user=#{data.user}"
      end
    end
  end
end
