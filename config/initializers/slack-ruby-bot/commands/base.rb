module SlackRubyBot
  module Commands
    class Base
      class << self
        alias_method :_invoke, :invoke
        alias_method :_send_message, :send_message

        def send_message(client, channel, text)
          Thread.current[:stdout] << text
          _send_message client, channel, "```#{text}```"
        end

        def invoke(client, data)
          _invoke client, data
        rescue Mongoid::Errors::Validations => e
          logger.info "#{name.demodulize.upcase}: #{client.team}, error - #{e.document.errors.first[1]}"
          send_message_with_gif client, data.channel, "```#{e.document.errors.first[1]}```", 'error'
          true
        rescue StandardError => e
          logger.info "#{name.demodulize.upcase}: #{client.team}, #{e.class}: #{e}"
          send_message_with_gif client, data.channel, "```#{e.message}```", 'error'
          true
        end

        # unescape a Slack message per https://api.slack.com/docs/formatting
        def unescape(message)
          CGI.unescapeHTML(message.gsub('“', '"').gsub(/<(?<sign>[?@#!]?)(?<dt>.*?)>/) do |_match|
            sign = $~[:sign]
            dt = $~[:dt]
            rhs = dt.split('|', 2).last
            case sign
            when '@', '!'
              "@#{rhs}"
            when '#'
              "##{rhs}"
            else
              rhs
            end
          end)
        end
      end
    end
  end
end
