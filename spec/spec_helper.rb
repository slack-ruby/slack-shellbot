$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..'))

ENV['RACK_ENV'] = 'test'
Bundler.require :default, ENV['RACK_ENV']

require 'slack-ruby-bot/rspec'
require 'slack-shellbot'

Dir[File.join(File.dirname(__FILE__), 'support', '**/*.rb')].each do |file|
  require file
end
