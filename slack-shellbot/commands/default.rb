module SlackShellbot
  module Commands
    class Default < SlackRubyBot::Commands::Base
      match(/^(?<bot>\w*)$/)

      def self.call(client, data, _match)
        send_message client, data.channel, SlackShellbot::INFO
        send_gif client, data.channel, 'robot'
      end
    end
  end
end
