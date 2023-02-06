# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: "from@h4ppyr0gu3.com"
  layout "mailer"
end
