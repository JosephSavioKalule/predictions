class ApplicationMailer < ActionMailer::Base
  default from: "noreply@soccer-predictions.herokuapp.com"
  layout 'mailer'
end
