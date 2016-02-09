module SlackShellbot
  module Commands
    class Mkdir < SlackRubyBot::Commands::Base
      def self.call(client, data, match)
        fs = client.owner.fs[data.channel]
        directory = Shellwords.split(match['expression']).first if match.names.include?('expression')
        fail 'usage: mkdir <directory> ...' unless directory
        directory_entry = fs.current_directory_entry.mkdir(directory)
        client.say(channel: data.channel, text: directory_entry.path)
        logger.info "MKDIR: #{client.owner}, #{fs}, directory=#{directory_entry.path}, user=#{data.user}"
      end
    end
  end
end
