Sidekiq.configure_server do |config|
  config.redis = { url:  ENV.fetch("REDIS_URL") {"redis://localhost:6379/12"} }
  # config.server_middleware do |chain|
  #   chain.add Sidekiq::RetryMonitoringMiddleware
  # end

  # require 'prometheus_exporter/instrumentation'
  # config.server_middleware do |chain|
  #   chain.add PrometheusExporter::Instrumentation::Sidekiq
  # end
  # config.death_handlers << PrometheusExporter::Instrumentation::Sidekiq.death_handler
  # config.on :startup do
  #   PrometheusExporter::Instrumentation::Process.start type: 'sidekiq'
  #   PrometheusExporter::Instrumentation::SidekiqProcess.start
  #   PrometheusExporter::Instrumentation::SidekiqQueue.start
  #   PrometheusExporter::Instrumentation::SidekiqStats.start
  # end
  config.on(:startup) do
    schedule_file = "config/schedule.yml"

    if File.exist?(schedule_file)
      Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
    end
  end
end

Sidekiq.configure_client do |config|
  config.redis = { url:  ENV.fetch("REDIS_URL") {"redis://localhost:6379/12"} }
end

