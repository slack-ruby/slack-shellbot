module SlackShellbot
  module Commands
    class Uname < SlackRubyBot::Commands::Base
      def self.call(client, data, _match)
        send_message client, data.channel, 'Shlack'
        logger.info "UNAME: #{client.team}, user=#{data.user}"
      end
    end
  end
end
