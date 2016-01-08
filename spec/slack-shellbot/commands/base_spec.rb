require 'spec_helper'

describe SlackRubyBot::Commands::Base do
  context '#unescape' do
    it 'plain text' do
      expect(SlackRubyBot::Commands::Base.unescape('plain text')).to eq 'plain text'
    end
    it 'HTML encoding' do
      expect(SlackRubyBot::Commands::Base.unescape('Hello &amp; &lt;world&gt;')).to eq 'Hello & <world>'
    end
    it 'user' do
      expect(SlackRubyBot::Commands::Base.unescape('Hey <@U024BE7LH|bob>, did you see my file?')).to eq 'Hey @bob, did you see my file?'
    end
    it 'url' do
      expect(SlackRubyBot::Commands::Base.unescape('This message contains a URL <http://foo.com/>')).to eq 'This message contains a URL http://foo.com/'
    end
    it 'url with value' do
      expect(SlackRubyBot::Commands::Base.unescape('So does this one: <http://www.foo.com|www.foo.com>')).to eq 'So does this one: www.foo.com'
    end
    it 'mailto' do
      expect(SlackRubyBot::Commands::Base.unescape('<mailto:bob@example.com|Bob>')).to eq 'Bob'
    end
    it 'linkify' do
      expect(SlackRubyBot::Commands::Base.unescape('Hello <@U123|bob>, say hi to <!everyone> in <#C1234|general>')).to eq 'Hello @bob, say hi to @everyone in #general'
    end
    it 'redirect' do
      expect(SlackRubyBot::Commands::Base.unescape('Hello <@U123|bob> &gt; file.txt')).to eq 'Hello @bob > file.txt'
    end
    it 'user' do
      expect(SlackRubyBot::Commands::Base.unescape('<@U02BEFY4U> ^^^')).to eq '@U02BEFY4U ^^^'
    end
  end
end
