module SlackShellbot
  module Commands
    class Echo < Base
      match(/^echo$/)
      match(/^echo([\s])?(?<text>.*)$/)

      def self.call(client, data, match)
        fs = client.owner.fs[data.channel]
        text = match['text'] if match.names.include?('text')
        client.say(channel: data.channel, text: text || "\n")
        logger.info "ECHO: #{client.owner}, #{fs}, text=#{text}, user=#{data.user}"
      end
    end
  end
end
