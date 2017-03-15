module SlackRubyBot
  class Client < Slack::RealTime::Client
    alias _say say

    def say(options = {})
      text = options[:text]
      if text
        Thread.current[:stdout] << text
        web_client.chat_postMessage(options.merge(text: "```#{text}```", as_user: true))
      else
        web_client.chat_postMessage(method, options.merge(as_user: true))
      end
    end
  end
end

Slack::RealTime::Client.configure do |config|
  config.store_class = Slack::RealTime::Stores::Starter
end
