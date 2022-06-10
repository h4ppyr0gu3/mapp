uri = "redis://#{ENV['REDIS_URL']}:#{ENV['REDIS_PORT']}/0/mapp" || 'redis://localhost:6379/0/mapp'
uri = "#{REDIS_URL}"

Rails.application.config.cache_store = :redis_store, uri
