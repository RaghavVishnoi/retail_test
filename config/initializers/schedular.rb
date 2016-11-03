require 'rufus-scheduler'
require 'tzinfo'
include RetailersHelper
# Let's use the rufus-scheduler singleton
 	
scheduler = Rufus::Scheduler.singleton
# scheduler.every '2s' do
# 	Rpush.push
# end
scheduler.cron '00 15 * * *' do
#scheduler.in '2s' do
	end_time = Time.now
	begin_time = '2013-01-01'#(end_time - 3.days).strftime("%Y-%m-%d")
	end_time = (end_time + 1.day).strftime("%Y-%m-%d")
	#SchedularMailer.sync(SYNC_EMAIL,begin_time,end_time,1).deliver!
 	zedsales_upload(begin_time,end_time)
end

scheduler.every '3h' do
	end_time = Time.now
	begin_time = (end_time - 1.days).strftime("%Y-%m-%d")
	end_time = (end_time + 1.day).strftime("%Y-%m-%d")
	SchedularMailer.sync(SYNC_EMAIL,begin_time,end_time,2).deliver!
 	zedsales_upload(begin_time,end_time)
end

scheduler.cron '00 17 * * *' do
	current_user = User.find_by_email(DOWNLOADER_EMAIL)
	start_date = Date.current.beginning_of_month
	end_date = Date.current
	RequestsCsv.new(start_date.to_s, end_date.to_s,'All',current_user).delay.generate
end

scheduler.cron '00 18 * * *' do
#scheduler.in '2s' do
	current_user = User.find_by_email(VMQA_ADMIN)
	start_date = Date.current.beginning_of_month
	end_date = Date.current
	RequestsCsv.new(start_date.to_s, end_date.to_s,'vmqa',current_user).delay.generate
end
 