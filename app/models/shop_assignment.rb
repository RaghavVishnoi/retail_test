class ShopAssignment < ActiveRecord::Base

	belongs_to :retailer
	belongs_to :user
	belongs_to :request
 
	validates :retailer_id, presence: true
	validates :user_id, presence: true
 	validate  :request_id
 	validate  :status
 	validate  :assignment_type

	def self.search(from,to,status,user_id)
		assignments = []
		self.where(created_at: from.to_date.beginning_of_day..to.to_date.end_of_day,status: status.split(','),user_id: user_id).each do |assignment|
			shop_assignment = {}
			shop_assignment[:shop] = assignment.retailer
			shop_assignment[:created_at] = assignment.created_at.strftime("%d %b, %Y")
			request = assignment.request if assignment.request_id != nil
			shop_assignment[:audited_on] = if request != nil then request.created_at.strftime("%d %b,%Y") else "N/A" end
			shop_assignment[:status] = assignment.status
			assignments.push(shop_assignment)
		end
		assignments
	end

	def self.available_assignment(current_user,state,city)
		case state
		when nil,'','All'
			@state = State.states_name(current_user)
  			Retailer.permit_retailers(current_user).where.not(id: pending_assignment.pluck(:retailer_id)).where(state: @state)
		else
			case city
			when nil,'','All'
			  	Retailer.permit_retailers(current_user).where.not(id: pending_assignment.pluck(:retailer_id)).where(state: state)
			else
				Retailer.permit_retailers(current_user).where.not(id: pending_assignment.pluck(:retailer_id)).where(state: state,city: city)
			end	
		end
	end

	def self.pending_assignment
		from = Time.now.to_date - 1.month
		to = Time.now.to_date
		self.where(status: 'pending',assign_date: from.beginning_of_day..to.end_of_day)
	end

	def self.create(params)
		@retailers = params[:retailer_id]
		@user_id = params[:user_id]
		@assign_date = Time.now
		if @retailers != nil
			@retailers.each do |retailer|
				self.create!(user_id: @user_id,retailer_id: retailer,assign_date: @assign_date)
			end
		end
 	end

 	def self.assignments(params,current_user)
  		case params[:sId]
 		when nil,'','undefined','Select Supervisor'
 			if current_user.roles.pluck(:name).include?('supervisor')
 				@assignments = ShopAssignment.where(user_id: UserParent.children(current_user.id,'auditor'))
 			else
 				@assignments = ShopAssignment.all
 			end
 			
 		else
 			user = User.find_by(auth_token: params[:sId])
 			if user != nil
 			auditor_id = UserParent.children(user.id,'auditor')		
	 			@assignments = ShopAssignment.where(user_id: auditor_id)
	 			case params[:aId]
		 		when nil,'','undefined'
		 			@assignments
		 		else
	 	 			@assignments = @assignments.where(user_id: User.find_by(auth_token: params[:aId]).id)
	 	 		end
 	 		end

 		end
 				
 		case params[:status]
 		when nil,'','undefined'
  			@assignments
 		else
 			@assignments = @assignments.where(status: params[:status])
 		end
 	end

 	def self.assignment_count(from,to,user_id,status)
 		if from == nil || from == '' || to == nil || to == ''
 			@from = Time.now.to_date - 1.month
 			@to = Time.now.to_date
 		else
 			@from = from.to_date
 			@to = to.to_date
 		end
  		self.where(created_at: @from.beginning_of_day..@to.end_of_day,status: status,user_id: user_id).count
 	end

 	def self.audit_date(assignment)
 		if assignment.status == 'pending' 
 			 "N/A"
 		else 
 			if assignment.request != nil
 				assignment.request.created_at
 			else
 				nil
 			end
 		end
 	end

end
