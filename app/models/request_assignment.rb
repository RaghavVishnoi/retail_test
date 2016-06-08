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



	def self.unassigned_requests
		Request.where.not(id: assigned_request.pluck(:request_id))
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
	 		count = self.where(user_id: user_id,current_stage: 'pending',assign_date: start_date.to_date.beginning_of_day..end_date.to_date.end_of_day).joins(:request).where('request_type = ?',request_type).count
	 	when 1
	 		count = self.where(user_id: user_id,current_stage: 'accepted',assign_date: start_date.to_date.beginning_of_day..end_date.to_date.end_of_day).joins(:request).where('request_type = ?',request_type).count
	 	when 2
	 		count = self.where(user_id: user_id,current_stage: 'started',assign_date: start_date.to_date.beginning_of_day..end_date.to_date.end_of_day).joins(:request).where('request_type = ?',request_type).count
	 	when 3
	 		count = self.where(user_id: user_id,current_stage: 'in_transit',assign_date: start_date.to_date.beginning_of_day..end_date.to_date.end_of_day).joins(:request).where('request_type = ?',request_type).count
	 	when 4
	 		count = self.where(user_id: user_id,current_stage: 'in_production',assign_date: start_date.to_date.beginning_of_day..end_date.to_date.end_of_day).joins(:request).where('request_type = ?',request_type).count
	 	when 5
	 		count = self.where(user_id: user_id,current_stage: 'installed',assign_date: start_date.to_date.beginning_of_day..end_date.to_date.end_of_day).joins(:request).where('request_type = ?',request_type).count
	 	when 6
	 		count = self.where(user_id: user_id,current_stage: 'declined',assign_date: start_date.to_date.beginning_of_day..end_date.to_date.end_of_day).joins(:request).where('request_type = ?',request_type).count
	 	
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
			puts "ssssss #{self.admin_type}"
			if self.admin_type == RRMS
				puts "inininin"
				self.is_rrm ||= true
			else
				self.is_valc ||= true
			end
		end

end
