class State < ActiveRecord::Base

	belongs_to :user_state
	has_many :requests

	def self.permit_state(user)
		if ['superadmin','approver'].include? User.get_role(user.id)
			State.all.pluck(:name,:id)
		else
			state_id = user.user_states.pluck(:state_id)	
			State.where(id: state_id).pluck(:name,:id)
		end
	end

	def self.state_with_name(user)
		if ['superadmin','approver'].include? User.get_role(user.id)
			State.all.pluck(:name,:name)
		else
			state_id = user.user_states.pluck(:state_id)
			State.where(id: state_id).pluck(:name,:name)
		end
	end

	def self.states(user)
		if ['superadmin','approver'].include? User.get_role(user.id)
			State.all.pluck(:id)
		else
			state_id = user.user_states.pluck(:state_id)
			State.where(id: state_id).pluck(:id)
		end
	end

	

end
