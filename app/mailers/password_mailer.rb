class PasswordMailer < ActionMailer::Base
  default from: "akash@gionee.co.in"

  def forgot_password_mail(email,password)
  	subject = "Forgot password"
  	@password = password
  	mail(to: email,subject: subject )
  end

end
