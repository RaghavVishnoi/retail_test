class SchedularMailer < ActionMailer::Base
  default :from => "mkt@gionee.co.in"

  helper :application

  def sync(email,start_date,end_date)
  	@start_date = start_date
  	@end_date = end_date
    mail(to: email, subject: 'Requester Sync Start')
  end
end  