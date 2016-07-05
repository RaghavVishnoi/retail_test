class RequestActivity < ActiveRecord::Base

	belongs_to :user
	belongs_to :request

	validate  :user_id
	validates :request_id, presence: true
	validates :request_status, presence: true
	validates :user_type, presence: true
	validate  :comment
	validate  :activity_date

 	
	def self.create_activity(user_id,request_id,request_status,user_type,comment,activity_date)
		self.create!(user_id: user_id,request_id: request_id,request_status: request_status,user_type: user_type,comment: comment,activity_date: activity_date)
	end

	def self.request_count_by_user(user_id,status,role,request_type,params,state)
		Request.where(request_type: request_type,created_at: date_range(params)[0].to_date..date_range(params)[1].to_date + 1.day,state_id: State.find_by(name: state).id).joins(:request_activities).where("request_activities.user_id= ? AND 
		request_activities.request_status= ? AND request_activities.user_type = ?",
	    user_id,status,role).count
	end

	def self.date_range(params)
		date = []
		case params[:from] 
			when nil,''
				date.push(Time.now - 1.month)
			else
				date.push(params[:from])
		end

		case params[:to]
			when nil,''
				date.push(Time.now)
			else
				date.push(params[:to])
		end

		date
			
	end

	def self.action_user(request_id,status)
 		status = status.split(',')
  		user = RequestActivity.find_by(request_id: request_id,request_status: status)
  		if user != nil && user.user_id != 0
			User.find(user.user_id).name
		else
			""
		end
	end

end
