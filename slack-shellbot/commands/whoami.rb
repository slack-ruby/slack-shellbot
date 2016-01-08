module SlackShellbot
  module Commands
    class Whoami < SlackRubyBot::Commands::Base
      def self.call(client, data, _match)
        send_message client, data.channel, "<@#{data.user}>"
        logger.info "UNAME: #{client.team}, user=#{data.user}"
      end
    end
  end
end
