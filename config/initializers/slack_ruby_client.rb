require 'slack-ruby-client'

module SlackShellbot
  module Web
    class Client < Slack::Web::Client
      attr_reader :owner

      def initialize(options = {})
        @owner = options[:team] if options && options.key?(:team)
        super
      end

      def update(options = {})
        text = options[:text]
        if text
          Thread.current[:stdout] << text
          chat_update(options.merge(text: "```#{text}```", as_user: true))
        else
          chat_update(method, options.merge(as_user: true))
        end
      end

      def say(options = {})
        text = options[:text]
        if text
          Thread.current[:stdout] << text
          chat_postMessage(options.merge(text: "```#{text}```", as_user: true))
        else
          chat_postMessage(method, options.merge(as_user: true))
        end
      end
    end
  end
end
