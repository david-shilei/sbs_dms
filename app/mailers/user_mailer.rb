class UserMailer < ActionMailer::Base
  default from: "admin@localhost"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.request_notification.subject
  #
  def request_notification(request)
    @request = request
    mail to: request.owner.email, subject: "Incoming request for downloading dataset"
  end
end
