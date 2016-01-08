module SlackRubyBot
  module Hooks
    module Message
      alias_method :_message, :message
      def message(client, data)
        Thread.current[:stdout] = []
        data = Hashie::Mash.new(data)
        if data.key?(:text)
          data.text = SlackRubyBot::Commands::Base.unescape(data.text)
          command, redirect_to = split_redirect(data.text)
          data.text = command if command
        end
        result = _message(client, data)
        if result && redirect_to.length > 0
          redirect_to = Shellwords.split(redirect_to).first
          fs = client.team.fs[data.channel]
          file_entry = fs.current_directory_entry.write(redirect_to, Thread.current[:stdout].join("\n"))
          SlackRubyBot::Commands::Base._send_message client, data.channel, "```#{file_entry.size} byte(s) written```"
          logger.info "WRITE: #{client.team}, #{fs}, file=#{file_entry}, user=#{data.user}"
        end
        result
      ensure
        Thread.current[:stdout] = nil
      end

      def split_redirect(text)
        parts = Shellwords.split(text)
        command = []
        while parts.any?
          part = parts.shift
          break if part == '>'
          command << part
        end
        [command.shelljoin, parts.shelljoin]
      end
    end
  end
end
