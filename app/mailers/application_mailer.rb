class ApplicationMailer < ActionMailer::Base
  default from: "no-reply@daycare.com"
  layout 'mailer'
end
