class UploadFileMailer < ActionMailer::Base
  default from: "mkt@gionee.co.in"

  def upload_confirmation
  	mail(to: 'akash@gionee.co.in',subject: 'Beatroute upload confirmation')
  end

  def upload_retailer_confirmation
  	mail(to: 'akash@gionee.co.in',subject: 'Retailer updation')
  end
  
end
