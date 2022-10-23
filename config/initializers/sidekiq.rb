Sidekiq.configure_server do |config|
  config.redis = { url:  ENV.fetch("REDIS_URL") {"redis://localhost:6379/12"} }

   config.server_middleware do |chain|
      require 'prometheus_exporter/instrumentation'
      chain.add PrometheusExporter::Instrumentation::Sidekiq
   end
end

Sidekiq.configure_client do |config|
  config.redis = { url:  ENV.fetch("REDIS_URL") {"redis://localhost:6379/12"} }
end

Sidekiq.strict_args!
