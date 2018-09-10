module SlackRubyBot
  module Hooks
    class Message
      alias _call call
      def call(client, data)
        return if message_to_self?(client, data)
        Thread.current[:stdout] = []
        data = Hashie::Mash.new(data)
        return if data.subtype
        if data.key?(:text)
          data.text = Slack::Messages::Formatting.unescape(data.text)
          command, redirect_to = split_redirect(data.text)
          data.text = command if command
        end
        fs = client.owner.fs[data.channel] if data.channel
        if fs && fs.program
          client.logger.info "PROGRAM: #{client.owner}, #{fs}, program=#{fs.program._type}, user=#{data.user}, message_ts=#{fs.program.message_ts}"
          fs.program.call client, data
          result = true
        else
          result = _call(client, data)
        end
        if result && redirect_to && !redirect_to.empty?
          redirect_to = Shellwords.split(redirect_to).first
          file_entry = fs.current_directory_entry.write(redirect_to, Thread.current[:stdout].join("\n"))
          client.web_client.chat_postMessage(channel: data.channel, text: "```#{file_entry.size} byte(s) written```", as_user: true)
          client.logger.info "WRITE: #{client.owner}, #{fs}, file=#{file_entry}, user=#{data.user}"
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
      rescue ArgumentError
        nil
      end
    end
  end
end
