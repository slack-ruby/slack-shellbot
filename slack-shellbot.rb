ENV['RACK_ENV'] ||= 'development'

require 'bundler/setup'
Bundler.require :default, ENV['RACK_ENV']

Dir[File.expand_path('../config/initializers', __FILE__) + '/**/*.rb'].each do |file|
  require file
end

Mongoid.load! File.expand_path('../config/mongoid.yml', __FILE__), ENV['RACK_ENV']

require 'faye/websocket'
require 'slack-ruby-bot'
require 'slack-shellbot/error'
require 'slack-shellbot/version'
require 'slack-shellbot/info'
require 'slack-shellbot/models'
require 'slack-shellbot/api'
require 'slack-shellbot/app'
require 'slack-shellbot/server'
require 'slack-shellbot/service'
require 'slack-shellbot/commands'
