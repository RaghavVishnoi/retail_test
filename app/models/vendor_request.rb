class VendorRequest < ActiveRecord::Base

	belongs_to :request_assignment


	state_machine :status, :initial => :cmo_pending do
    event :cmo_approve do
       transition :cmo_pending => :pending
    end
    event :cmo_decline do
       transition :cmo_pending => :cmo_declined
    end
    event :approve do
       transition :pending => :approved
    end
    event :decline do
       transition :pending => :declined
    end
  after_transition any => [:approved, :declined], :do => :update_request
  
  end
	
	validates :request_assignment_id, presence: true, uniqueness: true
	validates :installation_of, presence: true
	validates :installation_report, presence: true
	validates :status, presence: true
	validates :installed_on, presence: true
	validate :cmo_comment
	validate :cmo_response_date
	validate :rrm_comment
	validate :rrm_response_date

	def self.permit_requests(current_user)
		roles = current_user.roles.pluck(:name)
		if roles.include?(Cmo)
			request_ids = RequestActivity.where(user_type: 'CMO',user_id: current_user.id,request_status: CMO_APPROVED).pluck(:request_id)
		elsif roles.include?(RRMS)
			request_ids = RequestActivity.where(user_type: 'RRM',user_id: current_user.id,request_status: APPROVED).pluck(:request_id)
		elsif roles.include?(APPROVER)
			request_ids = RequestActivity.where('request_status IN (?)',[CMO_APPROVED,APPROVED]).pluck(:request_id)	
		end
	end

	def self.vendor_requests(current_user)
		request_ids = permit_requests(current_user)
		request_assignments_ids = RequestAssignment.where(request_id: request_ids).pluck(:id)
		all.where(request_assignment_id: request_assignments_ids)
	end

	def self.add_activity(params,current_user,vRequest)
		user = vRequest.request_assignment.user
		message = "#{current_user.name} has #{params[:commit] } #{user.name}'s assignment on request id #{vRequest.request_assignment.request_id}"
		if current_user.roles.pluck(:name).include?(RRMS)
			user_type = RRMS.upcase
		elsif current_user.roles.pluck(:name).include?(Cmo)
			user_type = Cmo.upcase
		else
			user_type = 'HO'
		end
		RequestAssignmentActivity.create!(user_type: user_type,user_id: current_user.id,status: vRequest.status,message: message,request_assignment_id: vRequest.request_assignment_id)			
	end

	def self.request_status(status,role)
		case role
		when 'CMO'
			case status
			when 'cmo_pending'
				'Pending'
			when 'cmo_declined'
				'Declined'
			when 'pending','approved','declined'
				'Approved'
			end	
		when 'RRM'
			case status
			when 'cmo_pending','cmo_declined'
				'Pending'
			when 'pending'
				'Pending'
			when 'approved'
				'Approved'
			when 'declined'
				'Declined'
			end	
		end
		
	end

	def self.isAssignentExists?(assignment)
		if assignment.vendor_request != nil
			if assignment.vendor_request.status != 'cmo_pending'
				true
			else
				false
			end
		else
			false
		end
	end
	
	private
		def update_request
			case self.status
			when APPROVED
				self.request_assignment.request.update(is_fixed: 2)
				self.request_assignment.update(current_stage: 'closed')
			when DECLINED
				self.request_assignment.request.update(is_fixed: 3)
				self.request_assignment.update(current_stage: 'declined')
			end
		end

  end
