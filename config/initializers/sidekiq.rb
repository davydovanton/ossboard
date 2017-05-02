require 'sidekiq-scheduler'

Sidekiq.configure_server do |config|
  config.redis = REDIS_SERVER
end

Sidekiq.configure_client do |config|
  config.redis = REDIS_CLIENT
end
