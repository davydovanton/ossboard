require 'dry-container'
require 'kramdown'
require 'rouge'

class Container
  extend Dry::Container::Mixin

  register :twitter do
    Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV["TWITTER_CONSUMER_KEY"]
      config.consumer_secret     = ENV["TWITTER_CONSUMER_SECRET"]
      config.access_token        = ENV["TWITTER_ACCESS_TOKEN"]
      config.access_token_secret = ENV["TWITTER_ACCESS_SECRET"]
    end
  end

  register :markdown do
    ->(text) { Markdown.parse(text) }
  end
end
