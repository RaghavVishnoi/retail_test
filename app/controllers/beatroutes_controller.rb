class BeatroutesController < ApplicationController
	  before_action :set_beatroute, :only => [:edit, :update,:previous_month_sales,:csv_insert]
    authorize_resource :only => [:create,:new,:previous_month_sales,:csv_insert]
    PER_PAGE = 1000


    def index
    	@beatroutes = Beatroute.all.order("created_at  desc,id desc").paginate(:per_page => PER_PAGE, :page => (params[:page] || 1))
    end

    def new 
      @beatroute = Beatroute.new
    end

    def create
       @beatroute = Beatroute.new beatroute_params
       if @beatroute.save
        redirect_to beatroutes_path, :notice=> "Record successfully inserted"
       else
        redirect_to new_beatroute_path, :notice => "Some internal error occurs"
       end
    end

    def update
     if @beatroute.update_attributes beatroute_params
        redirect_to beatroutes_path, notice: "Record updated successfully"
      else
        redirect_to :edit   
      end
    end

    def show
      if params[:id] == 'csv_insert'
        @result = Beatroute.insert_records
         render :json => @result
      else
    	 @beatroute = Beatroute.single_record(params[:bid])
      end
    end

    def file_upload
      result = Beatroute.save(params[:beatroute][:file])
      if result == 'success'
         redirect_to beatroutes_path, :notice => "File upload is under-process,you'll get email when done"
      elsif result == 'failure'
         redirect_to new_beatroute_path, :notice => "Please upload csv file"
      elsif result == 'wrong_format'
         redirect_to new_beatroute_path, :notice => "Please upload file with correct format"  
      end
    end

   def beatroute_params
      params.require(:beatroute).permit(:distributor_name,:tsm_name,:rsp_name,:rsp_id,:employee_code,:shop_code,:retailer_code,:retailer_name,:city,:last_month_avg_sales_volume,:last_month_avg_sales_value,:mtd_avg_sales_volume,:mtd_avg_sales_value,:avg_last_month_attendance,:last_reported_stock,:models_in_stock,:distance_btwn_beatroute_and_app_location,:sis_type,:sis_installed_on,:gsb_type,:gsb_installed_on,:clipon,:countertop,:flange,:standee,:inshop_branding,:sis,:gsb)
   end


    def set_beatroute
      @beatroute = Beatroute.where(:id => params[:id]).first
      unless @beatroute
        redirect_to beatroutes_url, alert: "Record not found"
      end
    end

end
