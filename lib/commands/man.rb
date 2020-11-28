module SlackShellbot
  module Commands
    class Man < Base
      match(/^man$/)

      HELP = <<~EOS.freeze
        Whoa! A bash shell in a Slack channel.

        General
        -------

        man                - get this helpful message
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
        fs = client.owner.fs[data.channel]
        client.say(channel: data.channel, text: HELP)
        logger.info "MAN: #{client.owner}, #{fs}, user=#{data.user}"
      end
    end
  end
end
