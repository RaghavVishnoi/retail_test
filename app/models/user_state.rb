class UserState < ActiveRecord::Base
	belongs_to :state
    belongs_to :user, :polymorphic => true

    def self.user(state_id,role)
		user_ids = self.where(state_id: state_id).pluck(:user_id)
		rrm = []
		user_ids.each do |user_id|
			user = UserData.find_by(user_id: user_id,status: 'Active')
			if AssociatedRole.find_by(object_id: user_id).role.name == role && user != nil && user.status == 'Active'
				rrm.push(user.name)
			end
		end
 		rrm

	end


end
