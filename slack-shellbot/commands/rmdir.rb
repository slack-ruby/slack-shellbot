module SlackShellbot
  module Commands
    class Rmdir < SlackRubyBot::Commands::Base
      match(/^rmdir([\s])?(?<path>.*)$/)

      def self.call(client, data, match)
        fs = client.owner.fs[data.channel]
        directory = Shellwords.split(match['path']).first if match.names.include?('path')
        raise 'usage: rmdir <directory> ...' unless directory

        directory_entry = fs.current_directory_entry.rmdir(directory)
        client.say(channel: data.channel, text: directory_entry.path)
        logger.info "RMDIR: #{client.owner}, #{fs}, directory=#{directory_entry.path}, user=#{data.user}"
      end
    end
  end
end
