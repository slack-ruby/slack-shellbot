module SlackShellbot
  module Commands
    class Rmdir < SlackRubyBot::Commands::Base
      def self.call(client, data, match)
        fs = client.team.fs[data.channel]
        directory = match['expression'] if match.names.include?('expression')
        fail 'usage: rmdir <directory> ...' unless directory
        directory_entry = fs.current_directory_entry.rmdir(directory)
        send_message client, data.channel, directory_entry.path
        logger.info "RMDIR: #{client.team}, #{fs}, directory=#{directory_entry.path}, user=#{data.user}"
      end
    end
  end
end
