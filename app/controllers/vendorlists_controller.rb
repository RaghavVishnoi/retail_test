class VendorlistsController < ApplicationController

    before_action :set_user, :only => [:edit, :update, :destroy]
  
	PER_PAGE = 20


	def index
        if params[:param] == nil || params[:param] == ''
		  @vendor = Vendorlist.all.paginate(:per_page => PER_PAGE, :page => (params[:page] || 1))
        else
          @vendor = Vendorlist.search(params[:param]).paginate(:per_page => PER_PAGE, :page => (params[:page] || 1))
              if @vendor.length < 1
                redirect_to vendorlists_path, notice: "No record found"
              else
                @search = params[:param]
              end 
        end  
        
	end

	def new 
		@vendor = Vendorlist.new
	end

	def create
		@vendor = Vendorlist.new vendor_params
		if @vendor.save
			redirect_to vendorlists_path, notice: "Vendor created successfully"
		else
			redirect_to new_vendorlist_path, notice: "Some fields are required"
		end	
    end

    def search
        
        @vendor = Vendorlist.search(params[:id])

        if @vendor == ''

            redirect_to vendors_path, notice: "Vendor not found"
        else
            redirect_to vendors_path
        end

    end

    def show
        @vendor = Vendorlist.find(params[:id])
    end

    def update 
    	if @vendor.update_attributes vendor_params
    	  redirect_to vendorlists_path, notice: "Vendor updated successfully"
	    else
	      redirect_to :edit		
	    end
    end

    def destroy
    	@vendor.destroy
        redirect_to vendorlists_path, notice: "Vendor deleted successfully from record"
    end

    def vendor_params
    	params.require(:vendorlist).permit(:region,:state,:vendor_name,:contact_person,:email,:status)
    end

    def set_user
      @vendor = Vendorlist.where(:id => params[:id]).first
      unless @vendor
        redirect_to vendorlists_url, alert: "User not found"
      end
    end


end
