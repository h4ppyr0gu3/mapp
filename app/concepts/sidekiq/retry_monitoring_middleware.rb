module Sidekiq
  class RetryMonitoringMiddleware
    def call(worker, job_params, _queue)
      worker.warn(job_params["jid"], *job_params["args"]) if should_warn?(worker, job_params)
    rescue StandardError => e
      Rails.logger.error e
    ensure
      yield
    end

    private

    def should_warn?(worker, job)
      worker.is_a?(Sidekiq::RetryMonitoringMiddleware::MonitoredWorker) &&
        (Integer(job["retry_count"]) + 1) == worker.threshold_retry_count_for_warn
    end
  end
end
