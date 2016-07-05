class RequestAssignment < ActiveRecord::Base

	attr_accessor :assigned_by,:admin_type

	before_create :add_admin_type
	after_create :add_request_assignment_activity

	belongs_to :user
	belongs_to :request
	has_many :request_documents, :as => :request_document, :dependent => :destroy
	has_many :vendor_stages

	validates :user_id, presence: true
	validates :request_id, presence: true
	validates :assign_date, presence: true
	validates :current_stage, presence: true
	validates :status, presence: true
	validates :user_type, presence: true


	def self.assignment(params)
		if params[:is_valc] == '1'
			if params[:states].split(',').include?('0')
		 		RequestAssignment.where(is_valc: true,assign_date: start_date(params[:from])..end_date(params[:to])).joins(:request).where('request_type = ?',params[:request_type])
		 	else
		 		RequestAssignment.where(is_valc: true,assign_date: start_date(params[:from])..end_date(params[:to])).joins(:request).where('request_type = ? AND state_id IN (?)',params[:request_type],params[:states].split(','))
		 	end
		else
			self.all
		end
	end


	def self.mass_assignment(params)
		params[:request_id].each do |request|
			if self.exists?(request_id: request)
				assignment = self.find_by(request_id: request)
				@assignment = assignment.update_attributes(user_id: params[:user_id],request_id: request,user_type: params[:user_type],assigned_by: params[:assigned_by],admin_type: params[:admin_type],priority: params[:priority],assign_date: Time.now,current_stage: 'pending',status: 'pending',is_rrm: assignment.is_rrm,is_valc: true)
			else
				@assignment = self.new(user_id: params[:user_id],request_id: request,user_type: params[:user_type],assigned_by: params[:assigned_by],admin_type: params[:admin_type],priority: params[:priority],assign_date: Time.now,current_stage: 'pending',status: 'pending')
				if @assignment.save!
					user = User.find(params[:assigned_by])
		 			message = "#{user.name} has assigned a request to #{User.find(params[:user_id]).name}"
					if user.roles.pluck(:name).include?('rrm')
						RequestAssignmentActivity.create!(user_type: 'rrm',status: 'pending',request_assignment_id: @assignment.id,message: message,user_id: params[:assigned_by])
					elsif user.roles.pluck(:name).include?('vendor allocator')
						RequestAssignmentActivity.create!(user_type: 'vendor allocator',status: 'pending',request_assignment_id: @assignment.id,message: message,user_id: params[:assigned_by])
					elsif user.roles.pluck(:name).include?('approver')
						RequestAssignmentActivity.create!(user_type: 'HO',status: 'pending',request_assignment_id: @assignment.id,message: message,user_id: params[:assigned_by])
					end
				end
			end
		end

	end

	def self.unassigned_requests(params)
		request_type = if params[:request_type] == nil then [0,1,2,3] else params[:request_type] end
		if params[:states] == '0' || params[:states] == nil
 			if params[:is_rrm] == 'true' || params[:is_rrm] == nil || params[:is_rrm] == true
				Request.where.not(id: self.where('status != ? AND (is_valc = true OR is_rrm = false)','declined').pluck(:request_id)).where(request_type: request_type,created_at: start_date(params[:from])..end_date(params[:to]),status: 'approved').joins(:request_assignment)
			else
 				Request.where.not(id: self.where('status != ? AND (is_valc = true OR is_rrm = true)','declined').pluck(:request_id)).where(request_type: request_type,created_at: start_date(params[:from])..end_date(params[:to]),status: 'approved')
			end
			
		else
			Request.where.not(id: self.where('status != ? AND is_valc = true','declined').pluck(:request_id)).where(request_type: request_type,created_at: start_date(params[:from])..end_date(params[:to]),state_id: params[:states],status: 'approved')
		end
	end

	def self.assigned_request
		self.where('status != ?','declined')
	end

	def self.user_info(user_id)
		data = {}
		user = UserData.find_by(user_id: user_id)
 		data[:grade] = user.grade
		assignments = self.where(user_id: user_id,user_type: 'vendor')
		data[:pending] = assignments.where(status: 'pending').count
		data[:in_process] = assignments.where(status: 'started').count
		data
	end

	def self.request_count_by_type(user_id,request_type,from,to,status)
	 	start_date = if from != '' && from != nil then from else (Time.now - 1.month).to_date end
    	end_date = if to != '' && to != nil then (Time.parse(to) + 1.day) else Time.now.to_date + 1 end
	 	case status
	 	when 0
	 		count = self.where(user_id: user_id,current_stage: 'pending',assign_date: start_date.to_date.beginning_of_day..end_date.to_date.end_of_day,is_valc: true).joins(:request).where('request_type = ?',request_type).count
	 	when 1
	 		count = self.where(user_id: user_id,current_stage: 'accepted',assign_date: start_date.to_date.beginning_of_day..end_date.to_date.end_of_day,is_valc: true).joins(:request).where('request_type = ?',request_type).count
	 	when 2
	 		count = self.where(user_id: user_id,current_stage: 'started',assign_date: start_date.to_date.beginning_of_day..end_date.to_date.end_of_day,is_valc: true).joins(:request).where('request_type = ?',request_type).count
	 	when 3
	 		count = self.where(user_id: user_id,current_stage: 'in_transit',assign_date: start_date.to_date.beginning_of_day..end_date.to_date.end_of_day,is_valc: true).joins(:request).where('request_type = ?',request_type).count
	 	when 4
	 		count = self.where(user_id: user_id,current_stage: 'in_production',assign_date: start_date.to_date.beginning_of_day..end_date.to_date.end_of_day,is_valc: true).joins(:request).where('request_type = ?',request_type).count
	 	when 5
	 		count = self.where(user_id: user_id,current_stage: 'installed',assign_date: start_date.to_date.beginning_of_day..end_date.to_date.end_of_day,is_valc: true).joins(:request).where('request_type = ?',request_type).count
	 	when 6
	 		count = self.where(user_id: user_id,current_stage: 'declined',assign_date: start_date.to_date.beginning_of_day..end_date.to_date.end_of_day,is_valc: true).joins(:request).where('request_type = ?',request_type).count
	 	
	 	end
	 	count
	 		 
	 end

	 def self.message(status,request_id,user)
	 	"#{user.name} has #{status} assignment on #{request_id}"
	 end

	 def self.add_activity(user_id,status,request_assignment)
	 	user = User.find(user_id)	 	
	 	RequestAssignmentActivity.create!(user_type: user.roles.pluck(:name).join(','),status: status,request_assignment_id: request_assignment.id,message: message(status,request_assignment.request_id,user),user_id: user_id)
	 end

	 def self.display_shop(assignments)
	 	assignments.map{|assignment| [display(assignment.request.retailer_code),assignment.id]}
	 end

	 def self.display(retailer_code)
	 	retailer = Retailer.find_by(retailer_code: retailer_code)
	 	"#{retailer_code} - #{retailer.retailer_name}"
	 end

	 def self.valc_pending_requests_counts(start_date,end_date,request_type,state_ids)
 	 	if state_ids.include?(0)
	 		Request.where.not(id: self.where('status != ? AND is_valc = true','declined').pluck(:request_id)).where(request_type: request_type,created_at: start_date(start_date)..end_date(end_date),status: 'approved').count
	 	else
	 		Request.where.not(id: self.where('status != ? AND is_valc = true','declined').pluck(:request_id)).where(request_type: request_type,created_at: start_date(start_date)..end_date(end_date),state_id: state_ids,status: 'approved').count
	 	end
	 	
	 end

	 def self.valc_assigned_requests_counts(start_date,end_date,request_type,state_ids)	 	
	 	if state_ids.include?(0)
	 		RequestAssignment.where(is_valc: true,assign_date: start_date(start_date)..end_date(end_date)).joins(:request).where('request_type = ?',request_type).count
	 	else
	 		RequestAssignment.where(is_valc: true,assign_date: start_date(start_date)..end_date(end_date)).joins(:request).where('request_type = ? AND state_id IN (?)',request_type,state_ids).count
	 	end
	 	
	 end

	 def self.valc_assignment_count(start_date,end_date,states)
	 	object = []
	 	ASSIGN_REQUEST_TYPE.each do |request_type|
	 		count = {};request = [];req = {}
	 		req[:pending] = valc_pending_requests_counts(start_date,end_date,request_type,states.map(&:to_i))
	 		req[:assigned] = valc_assigned_requests_counts(start_date,end_date,request_type,states.map(&:to_i))
	 		request.push(req)
	 		count[REQ_TYPE[request_type]] = request
	 		object.push(count)
	 	end
	 	object
	 end

	 def self.start_date(start_date)
		if start_date == nil
			(Time.now - 1.month)
		else	
			start_date.to_date.beginning_of_day
		end
	end

	def self.end_date(end_date)
		if end_date == nil
			Time.now
		else	
			end_date.to_date.end_of_day
		end
	end

	private
		def add_request_assignment_activity
			user = User.find(self.assigned_by)
 			message = "#{user.name} has assigned a request to #{User.find(self.user_id).name}"
			if user.roles.pluck(:name).include?('rrm')
				RequestAssignmentActivity.create!(user_type: 'rrm',status: 'pending',request_assignment_id: self.id,message: message,user_id: assigned_by)
			elsif user.roles.pluck(:name).include?('vendor_allocator')
				RequestAssignmentActivity.create!(user_type: 'vendor_allocator',status: 'pending',request_assignment_id: self.id,message: message,user_id: assigned_by)
			elsif user.roles.pluck(:name).include?('approver')
				RequestAssignmentActivity.create!(user_type: 'HO',status: 'pending',request_assignment_id: self.id,message: message,user_id: assigned_by)
			end
		end

		def add_admin_type
 			if self.admin_type == RRMS
 				self.is_rrm ||= true
			else
				self.is_valc ||= true
			end
		end

		

end
