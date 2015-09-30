class CmosController < ApplicationController

	before_action :set_user, :only => [:edit, :update, :destroy]
    skip_before_action :authenticate_user, :only => [:create, :new]
	PER_PAGE = 15


	def index
        if params[:param] == nil || params[:param] == ''
    		@cmo = CMO.all.paginate(:per_page => PER_PAGE, :page => (params[:page] || 1))
        else
            @cmo = CMO.search(params[:param])
              if @cmo.length < 1
                redirect_to cmos_path, notice: "No record found"
              else
                @search = params[:param]
              end 
        end
            
	end

	def new 
		@cmo = CMO.new
	end

	def create
		@cmo = CMO.new cmo_params
		if @cmo.save
			redirect_to cmos_path, notice: "CMO created successfully"
		else
            redirect_to new_cmo_path, :notice => @cmo.errors.messages.values[0][0]
		end	
    end
 
    def show
    	@cmo = CMO.find(params[:id])
    end

    def update 
    	if @cmo.update_attributes cmo_params
    	  redirect_to cmos_path, notice: "CMO updated successfully"
	    else
	      redirect_to edit_cmo_path, notice: "All fields are required"		
	    end
    end

     

    def destroy
    	@cmo.destroy
        redirect_to cmos_path, notice: "CMO deleted successfully from record"
    end

    def cmo_params
    	params.require(:cmo).permit(:name,:designation,:location,:email,:phone,:status)
    end

    def set_user
      @cmo = CMO.where(:id => params[:id]).first
      unless @cmo
        redirect_to cmos_url, alert: "CMO not found"
      end
    end

end
