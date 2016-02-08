class RequestsController < ApplicationController
  include RequestsHelper
  before_action :find_request, :only => [:edit, :update]
  authorize_resource :except => [:create, :new, :autocomplete_retailer_code,:state,:city,:previous_month_sales,:retailer_requests,:modify]
  skip_before_action :authenticate_user, :only => [:create, :new, :autocomplete_retailer_code,:state,:city,:previous_month_sales,:retailer_requests,:modify]
  PER_PAGE = 10
   
  def state
    value = params[:value]
    @city = Retailer.where(state: value).uniq.order("city asc")
    render :json => @city
  end

  def city
    value = params[:value]
    @retailer = Retailer.where(city: value,status: 'Active').uniq.order("city asc")
    render :json => @retailer
  end

    def index
      role = User.user_roles(session[:user_id])
      if role.include?('cmo')
        if params[:type] == 'RetailerCode' 
            @requests = Request.with_cmo_retailer_query(params[:q],current_user.id,params[:retailer_code]).includes(:images).order('updated_at asc').paginate(:per_page => PER_PAGE, :page => (params[:page] || 1))
          elsif params[:type] == 'State'
            @requests = Request.with_state_query(params[:q],params[:state],current_user).includes(:images).order('updated_at asc').paginate(:per_page => PER_PAGE, :page => (params[:page] || 1))
          else
            @requests = Request.with_cmo_query(params[:q],current_user.id).includes(:images).order('updated_at asc').paginate(:per_page => PER_PAGE, :page => (params[:page] || 1))
          end   
      elsif role.include?('supercmo') && params[:commit] == 'Search'
            @requests = Request.with_supercmo_query(params[:q][:status],params[:q][:request_type],params[:cmo]).includes(:images).order('updated_at asc').paginate(:per_page => PER_PAGE, :page => (params[:page] || 1))
      else
          if params[:type] == 'RetailerCode' 
            @requests = Request.with_retailer_query(params[:q],params[:retailer_code]).includes(:images).order('updated_at asc').paginate(:per_page => PER_PAGE, :page => (params[:page] || 1))
          elsif params[:type] == 'State'
            @requests = Request.with_state_query(params[:q],params[:state],current_user).includes(:images).order('updated_at asc').paginate(:per_page => PER_PAGE, :page => (params[:page] || 1))
          else
            @requests = Request.with_query(params[:q]).includes(:images).order('updated_at asc').paginate(:per_page => PER_PAGE, :page => (params[:page] || 1))
          end
      end      
  end

  def new
    @request = Request.new
    respond_to do |format|
      format.html 
      format.json { render :json => @request.as_json(:methods => [:shop_requirements, :branding_details]) }
    end
  end


  def create
    @request = Request.new request_params
    if @request.save
      if params[:request][:request_type] == 'visitor'
        @requests = Request.last 
        @requests.status = 'approved'
        @requests.save
      end
      respond_to do |format|
        format.html { redirect_to new_request_path, :notice => "Your Request has been submitted" }
        format.json { render :json => { :result => true } }
      end
    else
      respond_to do |format|
        format.html { render :new }
        format.json { render :json => { :result => false, :errors => { :messages => @request.errors.full_messages } } }
      end
    end
  end


  def edit
    @prev_url = request.referer
  end


   def update
    prev_url = params[:prev_url]
    id = session[:user_id] 
    @role = User.user_roles(id)
    comment = params[:comment]
    comment = comment.strip
    date = Time.now.to_date
    if  @role.include?('approver') ||  @role.include?('superadmin')   &&  params[:status] == "pending"
          date = Time.now.to_date
          @request.approver_approve_date = date
       if params[:commit] == "Approve"
          @request.approved_by_user_id = current_user.id
         if comment == ''
          @request.comment_by_approver = 'ok'
         else
          @request.comment_by_approver = comment
         end
         @request.approve
         redirect_to request.path+'/edit?alert=true'
       elsif params[:commit] == "Decline"
         @request.declined_by_user_id = current_user.id
         if comment == ''
          @request.comment_by_approver = 'Not Suitable'
         else
          @request.comment_by_approver = comment
         end
         @request.decline
         redirect_to prev_url
       end
        

    end

    if  @role.include?('cmo') ||  @role.include?('superadmin')  &&  params[:status] == "cmo_pending"
       @request.cmo_approve_date = date
       if params[:commit] == "Approve"
         if comment == ''
           @request.comment_by_cmo = 'ok'
         else
           @request.comment_by_cmo = comment
         end
         @request.cmo_approve
       elsif params[:commit] == "Decline"
         if comment == ''
           @request.comment_by_cmo = 'Not Suitable'
         else
           @request.comment_by_cmo = comment
         end
         @request.cmo_decline
       end
       if @request.errors.present?
          render :edit
       else
      redirect_to prev_url
       end

    end
   
  end

   def modify
      
        if params[:commit] == 'Update' && params[:status] != nil && params[:request_id] != nil
           status = Request.change_status(params[:status],params[:request_id])
           if status > 0
             redirect_to '/requests?q[request_type][]=0&q[request_type][]=1&q[request_type][]=2&q[status]=pending'
           else
             redirect_to request.referer,:notice => "Try again!"
           end
        elsif params[:retailer_code] != nil
          retailer_code = params[:retailer_code]
          if Retailer.where(:retailer_code => retailer_code).blank?
            redirect_to :back, :notice => "Entered Retailer Code is not valid"
          else
            request = Request.find_by(:id => params[:request_id])
            request.update(retailer_code: retailer_code)
            redirect_to :back, :notice => "successfully changed Retailer Code"
          end
        end
  end

  def view
       role = User.user_roles(current_user.id) 
      begin
         if role == 'cmo' && cmo_id != @request.cmo_id
               redirect_to :back, :flash => { :notice => "Sorry! You can't access this request" }
         else
               redirect_to requests_search(role,params[:type],params[:id],$request_type.to_s,current_user)
         end 
      rescue => ex
        begin
          redirect_to :back, :flash => { :notice => "Entered request id does not exist" }
        rescue
          redirect_to :back, :flash => { :notice => "Entered request id does not exist" }
        end
      end
  end
    

  def previous_month_sales
       retailer_code = params[:retailer_code]
       beatroute = Beatroute.where('created_at > ?' , Time.now.months_since(-1))
       @beatroute = beatroute.where(:retailer_code => retailer_code).order('id desc')
       @retailer = Retailer.where(:retailer_code => retailer_code)
       render :json => {:beatroute => @beatroute,:retailer => @retailer}
  end

  def retailer_requests
     @requests =  Request.retailer_requests(params[:retailer_code])
     render :json => {:requests => @requests}
  end

  def autocomplete_retailer_code
    @requests = Request.with_retailer_code(params[:q]).select(:retailer_code).uniq.paginate(:per_page => 100, :page => (params[:page] || '1'))
    @retailer_codes = @requests.map { |r| { :display_name => r.retailer_code } }
    render :json => { :result => true, :per_page => @requests.per_page, :length => @requests.length, :current_page => @requests.current_page, :total_pages => @requests.total_pages, :retailer_codes => @retailer_codes }
  end


  
  private

  def request_params
    params.require(:request).permit(:retailer_code, :rsp_name, :is_rsp, :rsp_not_present_reason, :rsp_mobile_number, :rsp_app_user_id,:other_name,:other_phone,:other_address,:lfr_name,:lfr_phone,:lfr_app_user_id,:state, :city, :shop_name, :shop_address, :shop_owner_name, :shop_owner_phone, :is_main_signage, :is_sis_installed, :space_available, :width, :height, :type_of_sis_required, :type_of_gsb_requested, :is_gsb_installed_outside, :avg_store_monthly_sales, :avg_gionee_monthly_sales, :cmo_id, :request_type, :remarks, :is_gionee_gsb_present,:maintenance_requestor,:maintenance_requestor_mobile_number,:type_of_issue,:type_of_problem, :image_ids_string,:shop_visit_date,:shop_visit_done_by,:visitor_contact_number,:is_clipon_present,:is_countertop_present,:is_leaflets_available,:no_of_peace_in_stock,:is_wall_poster_in_shop,:is_dangler_in_shop,:rsp_assigned_in_store,:rsp_present_in_shop,:rsp_in_gionee_tshirt,:rsp_well_groomed,:rsp_selling_skills,:gsb_type_installed,:location_of_gsb,:gsb_cleanliness,:installation_quality,:is_gsb_light_woring,:is_gsb_light_throw_is_good,:gsb_structured_damage,:gsb_other_problem,:gsb_retailer_feedback,:is_sis_present,:is_sis_placed_properly,:is_sis_condition_good,:is_sis_cleaned_daily,:is_sis_damaged,:is_standee_present,:store_selling_gionee,:sis_structured_flaws,:sis_security_alarm_working,:sis_security_device_charging,:sis_demo_phones_installed,:spec_card_demo_phone_match,:backwall_light_working_properly,:is_counter_lights_working,:is_clip_on_lights,:dealer_switch_on_sis_lights,:updated_gionee_creative,:sis_any_problem,:sis_retailer_feedback,:is_good_visibility_in_store,:lit_in_store,:has_a_relevant_visual,:overall_rating,:is_clipon_not_working_properly,:overall_comments,:user_id, :image_ids => [], :properties => [:field_id, :value, :values => []])
  end

  def find_request
    @request = Request.where(:id => params[:id]).first
    unless @request
      redirect_to requests_path
    end
  end
end
