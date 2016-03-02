module SlackRubyBot
  class Client
    # keep track of the team that the client is connected to
    attr_accessor :owner

    alias_method :_say, :say

    def update(options = {})
      say(options, :chat_update)
    end

    def say(options = {}, method = :chat_postMessage)
      text = options[:text]
      if text
        Thread.current[:stdout] << text
        web_client.send(method, options.merge(text: "```#{text}```", as_user: true))
      else
        web_client.send(method, options.merge(as_user: true))
      end
    end
  end
end
