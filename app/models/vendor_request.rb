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


	def self.vendor_requests(current_user)
		roles = current_user.roles.pluck(:name)
		if roles.include?(Cmo)
			request_ids = RequestActivity.where(user_type: 'CMO',user_id: current_user.id,request_status: CMO_APPROVED).pluck(:request_id)
		elsif roles.include?(RRMS)
			request_ids = RequestActivity.where(user_type: 'RRM',user_id: current_user.id,request_status: APPROVED).pluck(:request_id)
		elsif roles.include?(APPROVER)
			request_ids = RequestActivity.where('request_status IN (?)',[CMO_APPROVED,PENDING]).pluck(:request_id)	
		end
		all.joins(:request_assignment).where('request_id IN (?)',request_ids)
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
	
	private
		def update_request
			case self.status
			when APPROVED
				self.request_assignment.request.update(is_fixed: 2)
			when DECLINED
				self.request_assignment.request.update(is_fixed: 3)
			end
		end

  end
