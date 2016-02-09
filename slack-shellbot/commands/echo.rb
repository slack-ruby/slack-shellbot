module SlackShellbot
  module Commands
    class Echo < SlackRubyBot::Commands::Base
      def self.call(client, data, match)
        fs = client.owner.fs[data.channel]
        expression = match['expression'] if match.names.include?('expression')
        client.say(channel: data.channel, text: expression || "\n")
        logger.info "ECHO: #{client.owner}, #{fs}, expression=#{expression}, user=#{data.user}"
      end
    end
  end
end
