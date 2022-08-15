uri = "redis://#{ENV['REDIS_HOST']}:#{ENV['REDIS_PORT']}/12" || 'redis://localhost:6379/12'

# uri = "redis://redis:6379/0/mapp"
Rails.application.config.cache_store = :redis_store, uri
