module SlackShellbot
  module Commands
    class Cat < SlackRubyBot::Commands::Base
      def self.call(client, data, match)
        fs = client.team.fs[data.channel]
        file = Shellwords.split(match['expression']).first if match.names.include?('expression')
        fail 'usage: cat <file> ...' unless file
        file_entry = fs.current_directory_entry.find(file)
        send_message client, data.channel, file_entry.data
        logger.info "CAT: #{client.team}, #{fs}, file=#{file_entry}, user=#{data.user}"
      end
    end
  end
end
