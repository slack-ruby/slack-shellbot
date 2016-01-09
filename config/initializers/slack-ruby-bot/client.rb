module SlackRubyBot
  class Client
    # keep track of the team that the client is connected to
    attr_accessor :team

    alias_method :_say, :say

    def say(options = {})
      text = options[:text]
      Thread.current[:stdout] << text
      _say options.merge(text: "```#{text}```")
    end
  end
end
