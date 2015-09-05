class VendorTask < ActiveRecord::Base
	has_many :images, :as => :imageable, :dependent => :destroy
	has_many :vendorlist


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


    after_transition any => [:approved, :declined], :do => :notify_cmo
    
  end

   
	validate :request_id,:vendorlist,:requestor_type,:other_identity,:installation_of,:retailer_code,:installation_report,:vendor_id,:approver_approve_date,:cmo_approve_date,:comment_by_approver,:comment_by_cmo,:status
	

	  def image_ids_string=(str)
     self.image_ids = str.split(',')
    end


    def self.request_list(cmo_email)
    	@cmo = CMO.where(:email => cmo_email)
    	@cmo.each do |cmo|
    		@cmo_id = cmo.id
    	end
    	@request = Request.where(:cmo_id => @cmo_id)
    end
     
    def self.with_query(q)
    q = {} if !q.present? 
    requests = self
    if q[:status].present? 
          requests = requests.where(:status => q[:status])
    end
    requests
  end

  def self.cmo_id(id)
    
    user = User.find_by(:id => id)
    email = user.email
    associated_roles = AssociatedRole.find_by(:object_id => id)
    role = associated_roles.role
    cmo = CMO.find_by(:email => email)
    puts "here is cmo #{cmo}"
    cmo_id = cmo.id

end

def self.user_role(id)
  user = User.find_by(:id => id)
  associated_roles = AssociatedRole.find_by(:object_id => id)
  role = associated_roles.role
  
end

  def notify_cmo
    RequestMailer.delay.vendor_status_mail(id)
  end

end
