module SlackShellbot
  module Commands
    class Help < SlackRubyBot::Commands::Base
      HELP = <<~EOS.freeze
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

        vi                 - a basic vi-like in-place editor
         :wq               - quit and save current file
         :q                - quit without saving

EOS
      def self.call(client, data, _match)
        client.say(channel: data.channel, text: [HELP, SlackShellbot::INFO].join("\n"))
        client._say(channel: data.channel, gif: 'help')
        logger.info "HELP: #{client.owner}, user=#{data.user}"
      end
    end
  end
end
