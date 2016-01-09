module SlackShellbot
  module Commands
    class Pwd < SlackRubyBot::Commands::Base
      def self.call(client, data, _match)
        fs = client.team.fs[data.channel]
        client.say(channel: data.channel, text: fs.current_directory_entry.path)
        logger.info "PWD: #{client.team}, #{fs}, user=#{data.user}"
      end
    end
  end
end
