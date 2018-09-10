module SlackShellbot
  module Commands
    class Cd < SlackRubyBot::Commands::Base
      def self.call(client, data, match)
        fs = client.owner.fs[data.channel]
        directory = Shellwords.split(match['expression']).first if match.names.include?('expression')
        raise 'usage: cd directory ...' unless directory

        directory_entry = fs.cd(directory)
        client.say(channel: data.channel, text: directory_entry.path)
        logger.info "CD: #{client.owner}, #{fs}, directory=#{directory}, user=#{data.user}"
      end
    end
  end
end
