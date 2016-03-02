module SlackShellbot
  module Commands
    class Vi < SlackRubyBot::Commands::Base
      def self.call(client, data, match)
        fs = client.owner.fs[data.channel]
        filename = Shellwords.split(match['expression']).first if match.names.include?('expression')
        program = ViProgram.create!(filename: filename, file_system: fs)
        sent = client.say(channel: data.channel, text: program.to_s)
        program.update_attributes!(message_ts: sent.ts) if sent && sent.ts
        logger.info "VI: #{client.owner}, #{fs}, user=#{data.user}"
      end
    end
  end
end
