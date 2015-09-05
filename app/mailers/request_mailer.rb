class RequestMailer < ActionMailer::Base
  default :from => "mkt@gionee.co.in"

  helper :application

  def invite_mail(email, token)
    @token = token
    mail(to: email, subject: 'SignUp Invitation')
  end

  def status_mail(request_id)
    @request = Request.find request_id
    to = [@request.cmo.email, DEFAULT_EMAILS].flatten.compact
    subject = "Request Id - #{request_id} has been #{@request.status}."
    mail(to: to, subject: subject)
  end

  def vendor_status_mail(request_id)
    @request = VendorTaks.find request_id
    to = [@request.cmo.email, DEFAULT_EMAILS].flatten.compact
    subject = "Request Id - #{request_id} has been #{@request.status}."
    mail(to: to, subject: subject)
  end

  def csv_mail(emails, file_name)
    @file_name = file_name
    mail(to: emails, subject: 'CSV link')
  end
 
end