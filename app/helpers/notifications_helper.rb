module NotificationsHelper
	def self.notification_param(notification_params)
		state = notification_params[:state]
		app_id = notification_params[:app_id]
		message = notification_params[:message]
		registration_id(state,app_id,message)
	end

	def self.registration_id(state,app_id,message)
		device_registration_id = Device.where(:device_holder_state => state,:app_id => app_id).pluck(:device_registration_id)
		case app_id
			when '1'
				@app_name = 'RequesterApp'
				@auth_key = 'AIzaSyDRW9bdwFzlPtukm_qiHE9EVZTh2DCVfCA'
			when '2'
				@app_name = 'RequesterApp'
				@auth_key = 'AIzaSyDRW9bdwFzlPtukm_qiHE9EVZTh2DCVfCA'

		end
		send_notification(@app_name,device_registration_id,message,@auth_key)
	end

	 def self.send_notification(app_name,registration_ids,message,auth_key)
		begin
			app = Rpush::Gcm::App.all.where(:name => app_name)
			if app == nil
				app = Rpush::Gcm::App.new
				app.name = app_name
				app.auth_key = 'AIzaSyDRW9bdwFzlPtukm_qiHE9EVZTh2DCVfCA'
				app.connections = '1'
				app.save!
		    end

			n = Rpush::Gcm::Notification.new
			n.app = Rpush::Gcm::App.find_by_name(app_name)
			n.registration_ids = registration_ids
			n.data = { message: message }
			n.save!

			"success"
		rescue
			"failure"
		end	
	 end
end
