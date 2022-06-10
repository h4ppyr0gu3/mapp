Sidekiq.configure_server do |config|
  config.redis = { url:  "redis://#{ENV['REDIS_URL']}:#{ENV['REDIS_PORT']}/12" }
end

Sidekiq.configure_client do |config|
  config.redis = { url:  "#{ENV['REDIS_URL']}:#{ENV['REDIS_PORT']}/12" }
end
