module SlackShellbot
  module Commands
    class Pwd < Base
      match(/^pwd$/)

      def self.call(client, data, _match)
        fs = client.owner.fs[data.channel]
        client.say(channel: data.channel, text: fs.current_directory_entry.path)
        logger.info "PWD: #{client.owner}, #{fs}, user=#{data.user}"
      end
    end
  end
end
