module SlackShellbot
  module Commands
    class Uname < SlackRubyBot::Commands::Base
      def self.call(client, data, _match)
        client.say(channel: data.channel, text: 'Shell')
        logger.info "UNAME: #{client.team}, user=#{data.user}"
      end
    end
  end
end
