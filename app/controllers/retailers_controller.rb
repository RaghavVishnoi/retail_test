class RetailersController < ApplicationController
	before_action :set_retailer, :only => [:edit, :update, :destroy]
    authorize_resource :only => [:create,:new]
    PER_PAGE = 100
    

	def index 
        if params[:param] == nil || params[:param] == ''
		  @retailer = Retailer.all.paginate(:per_page => PER_PAGE, :page => (params[:page] || 1))
        else
          @retailer = Retailer.search(params[:param]).paginate(:per_page => PER_PAGE, :page => (params[:page] || 1))
          if @retailer.length < 1
            redirect_to retailers_path, notice: "Retailer not found"
          else
            @search = params[:param]
          end 
        end
	end

	def new 
		@retailer = Retailer.new
	end

	def create
		@retailer = Retailer.new retailer_params
		if @retailer.save
			redirect_to retailers_path, notice: "Retailer created successfully"
		else
            puts "error message #{@retailer.errors.messages.values}"
            redirect_to new_retailer_path, :notice => @retailer.errors.messages.values[0][0]
		end	
    end

    def file_upload
        @file_read = ReadFile.import(params[:retailer][:file],Retailer)
        render :json => @file_read
    end

    def file_insert
         @file = ReadFile.file_insert
        if params[:commit] == 'Confirm'
            @file_date = Retailer.insert_data(params[:new_array],params[:update_array],@file)
            redirect_to retailers_path, :notice => "Retailers file successfully imported"
        else
            redirect_to new_retailer_path, :notice => "Decline process"
        end
    end

    def search
        
        @retailer = Retailer.search(params[:id])

        if @retailer == ''

            redirect_to retailers_path, notice: "Retailer not found"
        else
            redirect_to retailers_path
        end

    end

    def show
    	@retailer = Retailer.find(params[:id])
    end

    def update 
    	if @retailer.update_attributes retailer_params
    	  redirect_to retailers_path, notice: "Retailer updated successfully"
	    else
	      redirect_to :edit		
	    end
    end

    def destroy
    	@retailer.destroy
        redirect_to retailers_path, notice: "Retailer deleted successfully from record"
    end

    def retailer_params
    	params.require(:retailer).permit(:retailer_code,:retailer_name,:sales_channel,:contact_person,:state,:city,:pincode,:tin_number,:mobile_number,:status,:is_isp_on_counter,:counter_size,:record_creation_date)
    end

    def set_retailer
      @retailer = Retailer.where(:id => params[:id]).first
      unless @retailer
        redirect_to retailers_url, alert: "Retailer not found"
      end
    end

end
