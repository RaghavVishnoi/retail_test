class FileMailer < ActionMailer::Base
  default :from => "FOSEM"

  def share_file_url(email, file_url)
    @file_url = file_url
    mail(to: email, subject: 'File')
  end
end