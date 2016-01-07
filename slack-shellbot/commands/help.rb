module SlackShellbot
  module Commands
    class Help < SlackRubyBot::Commands::Base
      HELP = <<-EOS
I am your friendly Shellbot, here to help.

General
-------

help       - get this helpful message

Shell
-----

ls         - list contents of a directory
pwd        - displays current directory
mkdir      - create a directory
rmdir      - remove a directory
touch      - create a file
        EOS
      def self.call(client, data, _match)
        send_message client, data.channel, [HELP, SlackShellbot::INFO].join("\n")
        send_gif client, data.channel, 'help'
        logger.info "HELP: #{client.team}, user=#{data.user}"
      end
    end
  end
end
