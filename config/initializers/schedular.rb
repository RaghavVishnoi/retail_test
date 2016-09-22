require 'rufus-scheduler'
require 'tzinfo'
include RetailersHelper
# Let's use the rufus-scheduler singleton
 	
scheduler = Rufus::Scheduler.singleton
# scheduler.every '2s' do
# 	Rpush.push
# end
scheduler.in '2s' do
	end_time = Time.now
	begin_time = (end_time - 3.days).strftime("%Y-%m-%d")
	end_time = (end_time + 1.day).strftime("%Y-%m-%d")
	SchedularMailer.sync(SYNC_EMAIL,begin_time,end_time).deliver!
 	zedsales_upload(begin_time,end_time)
end

scheduler.every '3h' do
	end_time = Time.now
	begin_time = (end_time - 1.days).strftime("%Y-%m-%d")
	end_time = (end_time + 1.day).strftime("%Y-%m-%d")
 	zedsales_upload(begin_time,end_time)
end
 