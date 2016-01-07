module SlackShellbot
  module Commands
    class Ls < SlackRubyBot::Commands::Base
      def self.call(client, data, _match)
        fs = client.team.fs[data.channel]
        dirs = fs.current_directory_entry.map(&:to_s).join("\n")
        send_message client, data.channel, "```#{dirs}```"
        logger.info "PWD: #{client.team}, #{fs}, #{data.user}"
      end
    end
  end
end
