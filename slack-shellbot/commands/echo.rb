module SlackShellbot
  module Commands
    class Echo < SlackRubyBot::Commands::Base
      def self.call(client, data, match)
        fs = client.team.fs[data.channel]
        expression = match['expression'] if match.names.include?('expression')
        send_message client, data.channel, expression || "\n"
        logger.info "ECHO: #{client.team}, #{fs}, expression=#{expression}, user=#{data.user}"
      end
    end
  end
end
