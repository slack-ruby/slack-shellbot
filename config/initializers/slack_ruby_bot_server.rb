SlackRubyBotServer.configure do |config|
  config.oauth_version = :v2
  config.oauth_scope = ['chat:write', 'im:history', 'mpim:history', 'channels:history', 'groups:history']
  config.server_pages do |pages|
    pages.cache_control = 'private, no-cache'
  end
end
