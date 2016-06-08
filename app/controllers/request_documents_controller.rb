class RequestDocumentsController < ApplicationController

	skip_authorize_resource

	def new
		@request_document = RequestDocument.new
	end

	def create
		@request_document = RequestDocument.new(request_document_params)
		if @request_document.save
			update_doc_upload
			send_request
			redirect_to session[:prev_url]
		else
			redirect_to session[:prev_url],notice: @request_document.errors.full_messages
		end
	end

private
	def request_document_params
		params.require(:request_document).permit(:request_document,:request_document_id,:request_document_type,:installation_of,:installation_report)
	end 

	def update_doc_upload
		RequestAssignment.find(request_document_params[:request_document_id]).update(upload_bill: 2)
	end

	def send_request
		RequestDocument.add_vendor_request(request_document_params)
	end

end
