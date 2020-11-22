# frozen_string_literal: true

require_relative 'support/match'

module SlackShellbot
  module Commands
    class Base
      include SlackRubyBotServer::Loggable

      class << self
        attr_accessor :command_classes

        def inherited(subclass)
          SlackShellbot::Commands::Base.command_classes ||= []
          SlackShellbot::Commands::Base.command_classes << subclass
        end

        def call(client, data)
          Thread.current[:stdout] = []
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
            result = command_classes.detect { |d| d.invoke(client, data) }
          end
          if result && redirect_to && !redirect_to.empty?
            redirect_to = Shellwords.split(redirect_to).first
            file_entry = fs.current_directory_entry.write(redirect_to, Thread.current[:stdout].join("\n"))
            client.chat_postMessage(channel: data.channel, text: "```#{file_entry.size} byte(s) written```", as_user: true)
            client.logger.info "WRITE: #{client.owner}, #{fs}, file=#{file_entry}, user=#{data.user}"
          end
          result
        rescue StandardError => e
          client.say(channel: data.channel, text: e.message)
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

        def command(*values, &block)
          values = values.map { |value| value.is_a?(Regexp) ? value.source : Regexp.escape(value) }.join('|')
          match Regexp.new("^sh[[:space:]](?<command>#{values})([[:space:]]+(?<expression>.*)|)$", Regexp::IGNORECASE | Regexp::MULTILINE), &block
        end

        def invoke(client, data)
          finalize_routes!

          expression = data.text

          routes.each_pair do |route, options|
            match_method = options[:match_method]
            case match_method
            when :match
              next unless expression

              match = route.match(expression)
              next unless match

              match = Support::Match.new(match)
            when :scan
              next unless expression

              match = expression.scan(route)
              next unless match.any?
            end
            call_command(client, data, match, options[:block])
            return true
          end
          false
        end

        def match(match, &block)
          routes[match] = { match_method: :match, block: block }
        end

        def scan(match, &block)
          routes[match] = { match_method: :scan, block: block }
        end

        def attachment(match, fields_to_scan = nil, &block)
          fields_to_scan = [fields_to_scan] unless fields_to_scan.nil? || fields_to_scan.is_a?(Array)
          routes[match] = {
            match_method: :attachment,
            block: block,
            fields_to_scan: fields_to_scan
          }
        end

        def routes
          @routes ||= ActiveSupport::OrderedHash.new
        end

        private

        def call_command(client, data, match, block)
          if block
            block.call(client, data, match) if permitted?(client, data, match)
          elsif respond_to?(:call)
            send(:call, client, data, match) if permitted?(client, data, match)
          else
            raise NotImplementedError, data.text
          end
        end

        def direct_message?(data)
          data.channel && data.channel[0] == 'D'
        end

        def message_from_another_user?(data)
          data.user && data.user != SlackRubyBot.config.user_id
        end

        def finalize_routes!
          return if routes&.any?

          command command_name_from_class
        end

        def match_attachments(data, route, fields_to_scan = nil)
          fields_to_scan ||= %i[pretext text title]
          data.attachments.each do |attachment|
            fields_to_scan.each do |field|
              next unless attachment[field]

              match = route.match(attachment[field])
              return match, attachment, field if match
            end
          end
          false
        end

        # Intended to be overridden by subclasses to hook in an
        # authorization mechanism.
        def permitted?(_client, _data, _match)
          true
        end
      end
    end
  end
end
