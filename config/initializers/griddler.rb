require_relative '../../app/concepts/email_processor.rb'

Griddler.configure do |config|
  config.processor_class = EmailProcessor 
  config.email_class = Griddler::Email 
  config.processor_method = :process 
  config.reply_delimiter = '-- REPLY ABOVE THIS LINE --'
  config.email_service = :sendgrid 
end
