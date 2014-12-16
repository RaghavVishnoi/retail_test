class UserMailer < ActionMailer::Base
  default :from => "FOSEM"

  def invite_mail(email, token)
    @token = token
    mail(to: email, subject: 'SignUp Invitation')
  end
end