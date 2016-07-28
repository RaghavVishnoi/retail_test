class UserMailer < ActionMailer::Base
  default :from => "FOSEM"

  def invite_mail(email, token)
    @token = token
    mail(to: email, subject: 'SignUp Invitation')
  end

  def reset_password_token(email, token)
    @token = token
    mail(to: email, subject: 'Reset Password')
  end
end