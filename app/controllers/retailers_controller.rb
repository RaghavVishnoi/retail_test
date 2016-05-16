class RetailersController < ApplicationController
  include RetailersHelper
	  before_action :set_retailer, :only => [:edit, :update, :destroy,:upload_data]
    authorize_resource :only => [:create,:new]
    
    PER_PAGE = 100
    
    
	def index 
 		  @retailer = Retailer.select(params,current_user).paginate(:per_page => PER_PAGE, :page => (params[:page] || 1))
        
	end

	def new 
		@retailer = Retailer.new
	end

	def create
		@retailer = Retailer.new retailer_params
		if @retailer.save
			redirect_to retailers_path, notice: "Retailer created successfully"
		else
            redirect_to new_retailer_path, :notice => @retailer.errors.messages.values[0][0]
		end	
    end

    def file_upload
        @file_read = ReadFile.import(params[:retailer][:file],Retailer)
        render :json => @file_read
    end

    def file_insert
        @file = ReadFile.file_insert(params[:new_array],params[:update_array])
        redirect_to retailers_path, :notice => "File upload in process,you'll get mail once done"
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
        if params[:id] == 'upload_data'
           @upload = Retailer.file_to_upload
           puts "here is upload #{@upload}"
           @upload.each do |upload|
                new_retailers = Retailer.new_retailers(upload)
                update_retailers = Retailer.update_retailers(upload)
                url = "public/uploads/retailer/upload/"+upload.id.to_s+"/"+upload.file_name.to_s
                @file_data = Retailer.insert_data(new_retailers,update_retailers,url,upload)
            end 
         if @file_data == 'success'
            render :json => {:result => @file_data}
         else
            render :json => {:result => 'No Data'}
         end
        else
    	  @retailer = Retailer.find(params[:id])
        end
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
    	params.require(:retailer).permit(:retailer_code,:retailer_name,:address,:sales_channel,:contact_person,:state,:city,:pincode,:tin_number,:mobile_number,:status,:is_isp_on_counter,:counter_size,:record_creation_date)
    end

    def set_retailer
      @retailer = Retailer.where(:id => params[:id]).first
      unless @retailer
        redirect_to retailers_url, alert: "Retailer not found"
      end
    end

    def zed_sales
      zedsales_upload('','')
    end 

end
