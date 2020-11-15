module SlackShellbot
  module Commands
    class Default < SlackRubyBot::Commands::Base
      match(/^(?<bot>\w*)$/)

      def self.call(client, data, _match)
        client.say(channel: data.channel, text: SlackShellbot::INFO)
        client._say(channel: data.channel)
      end
    end
  end
end
