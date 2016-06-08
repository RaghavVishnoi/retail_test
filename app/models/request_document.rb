class RequestDocument < ActiveRecord::Base

	attr_accessor :installation_of,:installation_report

	mount_uploader :request_document, RequestDocumentUploader
 	#belongs_to :request_document, :polymorphic => true

  	validates :request_document, presence: true
  	validates :request_document_id, presence: true

  	def self.add_vendor_request(params)
  		vendor_request	=  VendorRequest.create!(request_assignment_id: params[:request_document_id],installation_of: params[:installation_of],installation_report: params[:installation_report],status: 'cmo_pending',installed_on: Time.now)
  		if vendor_request
  			request_assignment = RequestAssignment.find(params[:request_document_id])
  			user = User.find(request_assignment)
  			message = "#{user.name} has submitted documents for installation"
  			RequestAssignmentActivity.create!(user_id: request_assignment.user_id,status: 'document_upload',user_type: 'vendor',request_assignment_id: request_assignment.id,message: message)
  		end
  	end

end