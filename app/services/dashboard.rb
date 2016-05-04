class Dashboard
	

	def self.data(current_user,params)
 		if params[:v] == 'rrm' 
 			users = User.where(status: 'Active',id: AssociatedRole.where(role_id: Role.find_by(name: 'rrm').id).pluck(:object_id))
 			@response = []
 			users.each do |user|
 				data = {}
 				data[:name] = user.name
 				data[:user_id] = user.id
 				states = State.where(id: UserState.where(user_id: user.id).pluck(:state_id))
 				data[:states] = states.select(:id,:name)
 				@response.push(data)
  			end
 			@response
		else
				permit_state = State.permit_state(current_user)
			  	@response = []
			  	permit_state.each do |state_data|
			  		data = {}
			  		data[:state] = state_data[0]
			  		if User.user_roles(current_user.id).include? 'cmo'
			  			response = {}
				  		sql = "select temp.object_id from (select ar.object_id from associated_roles
				  				 as ar JOIN  roles as role  ON ar.role_id = role.id 
				  				 where role.name = 'rrm') as temp JOIN user_states as us ON us.user_id=temp.object_id where us.state_id=#{state_data[1]}"
				  		@result = ActiveRecord::Base.connection.execute(sql)
				  		@result.each do |result|
				  			@rrm  = User.where(id: result[0]).pluck(:name)
				  		end
				  		response[:rrm] = @rrm
				  		response[:state] = state_data[0]
						@response.push(response)	
			  		else
				  		rrm = []
				  		cmo = []
				  		state_id = state_data[1]
				  		user_ids = UserState.where(state_id: state_id).pluck(:user_id)		  		
				  		user_ids.each do |user_id|
				  			if User.where(id: user_id,status: 'Active').length != 0
					  			roles = User.user_roles(user_id)
					  			
		 			  			user_data = UserData.find_by(user_id: user_id,status: 'Active')
 		 			  			if roles.include? 'rrm' 
		 			  				if user_data != nil
		 			  					puts "enter user_data.user"
					  					rrm.push(user_data.user)
					  				end
					  			end
					  			if roles.include? 'cmo'
					  				if user_data != nil
					  					cmo.push(user_data.user)
					  				end
					  			end
					  		end	
				  		end
				  		data[:rrm] = rrm
				  		data[:cmo] = cmo
				  		@response.push(data)
				  	end	
			  	end
		  	@response		
		end  	  	
	end

end