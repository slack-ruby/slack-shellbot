module SlackShellbot
  module Commands
    class Help < SlackRubyBot::Commands::Base
      HELP = <<-EOS
I am your friendly Shellbot, here to help.

General
-------

help               - get this helpful message
uname              - print the operating system name
whoami             - print your username

Shell
-----

ls                 - list contents of a directory
pwd                - displays current directory
echo               - display a message
mkdir <directory>  - create a directory
rmdir <directory>  - remove a directory
touch <file>       - create a file
rm <file>          - remove a file
cat <file>         - show contents of a file

Programs
--------

vi                 - a basic vi-like editor, :wq to quit

EOS
      def self.call(client, data, _match)
        send_message client, data.channel, [HELP, SlackShellbot::INFO].join("\n")
        send_gif client, data.channel, 'help'
        logger.info "HELP: #{client.team}, user=#{data.user}"
      end
    end
  end
end
