require 'logster'

if Rails.env.production?
    Rails.logger.extend(ActiveSupport::Logger.broadcast(Logster.logger))
end
