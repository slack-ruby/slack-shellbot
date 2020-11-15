module SlackShellbot
  module Commands
    class Cd < SlackRubyBot::Commands::Base
      match(/^cd([\s])?(?<path>.*)$/)

      def self.call(client, data, match)
        fs = client.owner.fs[data.channel]
        directory = Shellwords.split(match['path']).first if match.names.include?('path')
        raise 'usage: cd directory ...' unless directory

        directory_entry = fs.cd(directory)
        client.say(channel: data.channel, text: directory_entry.path)
        logger.info "CD: #{client.owner}, #{fs}, directory=#{directory}, user=#{data.user}"
      end
    end
  end
end
