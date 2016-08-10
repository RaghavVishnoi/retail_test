require 'rufus-scheduler'
require 'tzinfo'
include RetailersHelper
# Let's use the rufus-scheduler singleton
 	
scheduler = Rufus::Scheduler.singleton
# scheduler.every '2s' do
# 	Rpush.push
# end
 
scheduler.cron '05 01 * * *' do
	end_time = Time.now
	begin_time = end_time.yesterday.strftime("%Y-%m-%d")
	end_time = end_time.strftime("%Y-%m-%d")
	zedsales_upload(begin_time,end_time)
end
 