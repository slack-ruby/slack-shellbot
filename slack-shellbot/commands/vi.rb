module SlackShellbot
  module Commands
    class Vi < SlackRubyBot::Commands::Base
      def self.call(client, data, match)
        fs = client.team.fs[data.channel]
        filename = Shellwords.split(match['expression']).first if match.names.include?('expression')
        program = ViProgram.create!(filename: filename, file_system: fs)
        send_message client, data.channel, program.to_s
        logger.info "VI: #{client.team}, #{fs}, user=#{data.user}"
      end
    end
  end
end
