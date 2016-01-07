class Notification < ActiveRecord::Base
	has_one :rpush_notifications
	validates :state,:presence => true
	validates :message,:presence => true
	validates :app_id,:presence => true

	
end
