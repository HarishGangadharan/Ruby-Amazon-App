class UserMailer < ActionMailer::Base
  default from: "'Harish' <from@example.com>"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.reset_password.subject
  #
  def reset_password(email, token)
  @token = token;

    mail to: email,  subject: "Reset Password"
  end
end
