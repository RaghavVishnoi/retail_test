class RequestDocumentsController < ApplicationController

	skip_authorize_resource :only => [:create]

	def new
		@request_document = RequestDocument.new
	end

	def create
		@request_document = RequestDocument.new(request_document_params)
		if RequestDocument.exists?(request_document_id: request_document_params[:request_document_id]) and params["request_document"]["request_document"].present?
			request_ids_to_delete = RequestDocument.where(["request_document_id = ?", request_document_params[:request_document_id]]).map(&:id)
		end
		update_doc_upload
		send_request
		if @request_document.save
			RequestDocument.where(:id => request_ids_to_delete).destroy_all
			redirect_to session[:prev_url]
		else
			redirect_to session[:prev_url],notice: @request_document.errors.full_messages[0]
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
