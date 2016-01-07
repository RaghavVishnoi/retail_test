require 'rufus-scheduler'
require 'tzinfo'
include RetailersHelper
# Let's use the rufus-scheduler singleton
 	
scheduler = Rufus::Scheduler.singleton
scheduler.cron '5 0 * * *' do
	end_time = Time.now
    begin_time = end_time.yesterday
	zedsales_upload(begin_time,end_time)
end