class ApplicationMailer < ActionMailer::Base
  default from: 'no-reply@test-blog.com'
  layout 'mailer'
end
