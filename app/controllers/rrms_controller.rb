class RrmsController < ApplicationController
	before_action :set_user, :only => [:edit, :update, :destroy]
    skip_before_action :authenticate_user, :only => [:create, :new]
    authorize_resource
	PER_PAGE = 15

	def index
		if params[:param] == nil || params[:param] == ''
    		@rrm = RRM.all.paginate(:per_page => PER_PAGE, :page => (params[:page] || 1))
        else
            @rrm = RRM.search(params[:param])
              if @rrm.length < 1
                redirect_to rrms_path, notice: "No record found"
              else
                @search = params[:param]
              end 
        end
            
	end

	def new
		@rrm =  RRM.new
	end

	def create
		@rrm =  RRM.new(parameters)
		if @rrm.save
			redirect_to rrm_path(@rrm),notice: "RRM created successfully"
		else
			render 'new',:notice => @rrm.errors.messages.values[0][0]
		end
	end

	def show
		@rrm = RRM.find(params[:id])
	end

	def update
		if @rrm.update_attributes parameters
    	  redirect_to rrms_path, notice: "RRM updated successfully"
	    else
	      redirect_to edit_rrm_path, notice: "All fields are required"		
	    end
	end

	def destroy
		@rrm.destroy
        redirect_to rrms_path, notice: "RRM deleted successfully from record"
	end


	private
		def parameters
			params.require(:rrm).permit(:name,:designation,:location,:email,:phone,:status)
		end

		def set_user
	      @rrm = RRM.where(:id => params[:id]).first
	      unless @rrm
	        redirect_to rrms_url, alert: "RRM not found"
	      end
  		end

end
