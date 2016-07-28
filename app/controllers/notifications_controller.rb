class NotificationsController < ApplicationController
	include NotificationsHelper

	authorize_resource :only => [:create,:new]
	PER_PAGE = 50;

	def index
		@notifications = Notification.all.paginate(:per_page => PER_PAGE, :page => (params[:page] || 1))
	end

	def new 
		@notification = Notification.new
	end

	def create
		@result = NotificationsHelper.notification_param(notification_params)
		if @result == "success"
			@notification = Notification.new notification_params
			@notification.send_date = Time.now
			@notification.status = 'success'
			@notification.save
			redirect_to notifications_path
		else
			@notification = Notification.create(notification_params,'Failure')
			redirect_to new_notification_path
		end
				
	end

	def notification_params
		params.require(:notification).permit(:state,:app_id,:message)
	end

end
