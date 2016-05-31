class UserAudit < ActiveRecord::Base

	def self.audits(current_user,params)
 		users = (User.where(status: 'Active').joins(:roles).where('roles.name = "supervisor"')).joins(:states).where('states.id IN(?)',State.states(current_user))
 		@response = []
 		users.each do |user|
 			response = {}
 			response[:supervisor] = user
 			response[:auditor] = UserParent.children(user.id,'auditor')
 			@response.push(response) 
 		end
 		@response
	end

end