module SlackShellbot
  module Commands
    class Cd < SlackRubyBot::Commands::Base
      def self.call(client, data, match)
        fs = client.team.fs[data.channel]
        directory = match['expression'] if match.names.include?('expression')
        fail 'usage: cd directory ...' unless directory
        directory_entry = fs.cd(directory)
        send_message client, data.channel, directory_entry.path
        logger.info "CD: #{client.team}, #{fs}, directory=#{directory}, user=#{data.user}"
      end
    end
  end
end
