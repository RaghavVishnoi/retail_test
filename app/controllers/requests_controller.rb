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
    @retailer = Retailer.where(city: value,status: ACTIVE).uniq.order("city asc")
    render :json => @retailer
  end

  def index
      session[:prev_url] = request.fullpath
      @requests = Request.find_requests(current_user,params).paginate(:per_page => PER_PAGE, :page => (params[:page] || 1))        
  end

  def new
    @request = Request.new
    respond_to do |format|
      format.html 
      format.json { render :json => @request.as_json(:methods => [:shop_requirements, :branding_details]) }
    end
  end


  def create
      rparams = request_params
      if ["Faridabad","Gurgaon"].include?(request_params[:city])      
        rparams[:state_id] = 10
        request_params = rparams
      else
        request_params = rparams
      end
      @request = Request.new request_params

    if @request.save      
      if params[:request][:request_type] == 'visitor'
        @requests = Request.last 
        @requests.status = 'approved'
        @requests.save
        @request_activity = RequestActivity.create_activity(0,@request.id,'approved','RRM','',Time.now)
      else
        @request_activity = RequestActivity.create_activity(0,@request.id,'cmo_pending','CMO','',Time.now)
      end
      respond_to do |format|
        format.html { redirect_to new_request_path, :notice => "Your Request has been submitted" }
        format.json { render :json => { :result => true,:data => {request_id: @request.id,request_type: @request.request_type.camelize} } }
      end
    else
      respond_to do |format|
        format.html { render :new }
        format.json { render :json => { :result => false, :errors => { :messages => @request.errors.full_messages } } }
      end
    end
  end


  def edit
    @request = Request.find(params[:id])
  end


   def update
     id = current_user.id
    @role = User.user_roles(id)
    comment = params[:comment]
    comment = comment.strip
    date = Time.now.to_date
    if  (@role.include?('rrm') || @role.include?('approver') ||  @role.include?('superadmin'))   &&  params[:status] == "pending"
          date = Time.now.to_date
          @request.approver_approve_date = date
       if params[:commit] == APPROVE
          @request.approved_by_user_id = current_user.id
         if comment == ''
          @request.comment_by_approver = 'ok'
         else
          @request.comment_by_approver = comment
         end
         @request.approve
         @request_activity = RequestActivity.create_activity(current_user.id,@request.id,'approved',if @role.include?('approver') then 'HO' else 'RRM' end,@request.comment_by_approver,Time.now)
         redirect_to request.path+'/edit?q[request_type]='+@request.request_type+'&alert=true'
       elsif params[:commit] == DECLINE
         @request.declined_by_user_id = current_user.id
         if comment == ''
          @request.comment_by_approver = 'Not Suitable'
         else
          @request.comment_by_approver = comment
         end
         @request.decline
          @request_activity = RequestActivity.create_activity(current_user.id,@request.id,@request.status,if @role.include?('approver') then 'HO' else 'RRM' end,@request.comment_by_approver,Time.now)
         redirect_to session[:prev_url]
       end
        

    end

    if  (@role.include?('cmo') ||  @role.include?('superadmin') ||  @role.include?('approver'))  &&  params[:status] == "cmo_pending"
       @request.cmo_approve_date = date
       if params[:commit] == APPROVE
         if comment == ''
           @request.comment_by_cmo = 'ok'
         else
           @request.comment_by_cmo = comment
         end
          @request.cmo_approve
          @request_activity = RequestActivity.create_activity(current_user.id,@request.id,'cmo_approved',if @role.include?('approver') then 'HO' else 'CMO' end,@request.comment_by_cmo,Time.now)
          @request_activity = RequestActivity.create_activity(current_user.id,@request.id,'pending',if @role.include?('approver') then 'HO' else 'CMO' end,@request.comment_by_cmo,Time.now)
          redirect_to request.path+'/edit?q[request_type]='+@request.request_type
       elsif params[:commit] == DECLINE
           if comment == ''
              @request.comment_by_cmo = 'Not Suitable'
           else
              @request.comment_by_cmo = comment
           end
          @request.cmo_decline
          @request_activity = RequestActivity.create_activity(current_user.id,@request.id,'cmo_declined',if @role.include?('approver') then 'HO' else 'CMO' end,@request.comment_by_cmo,Time.now) 
          redirect_to request.path+'/edit?q[request_type]='+@request.request_type
       end
        
    end
   
  end

   def modify
      
        if params[:commit] == 'Update' && params[:status] != nil && params[:request_id] != nil
           status = Request.change_status(params[:status],params[:request_id])
           if status > 0
             redirect_to PENDING_URL
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
         if role == CMO && cmo_id != @request.cmo_id
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
    params.require(:request).permit(:retailer_code, :rsp_name, :is_rsp,:state_id, :rsp_not_present_reason, :rsp_mobile_number, :rsp_app_user_id,:other_name,:other_phone,:other_address,:lfr_name,:lfr_phone,:lfr_app_user_id,:state, :city, :shop_name, :shop_address, :shop_owner_name, :shop_owner_phone, :is_main_signage, :is_sis_installed, :space_available, :width, :height, :type_of_sis_required, :type_of_gsb_requested, :is_gsb_installed_outside, :avg_store_monthly_sales, :avg_gionee_monthly_sales, :cmo_id, :request_type, :remarks, :is_gionee_gsb_present,:maintenance_requestor,:maintenance_requestor_mobile_number,:type_of_issue,:type_of_problem, :image_ids_string,:shop_visit_date,:shop_visit_done_by,:visitor_contact_number,:is_clipon_present,:is_countertop_present,:is_leaflets_available,:no_of_peace_in_stock,:is_wall_poster_in_shop,:is_dangler_in_shop,:rsp_assigned_in_store,:rsp_present_in_shop,:rsp_in_gionee_tshirt,:rsp_well_groomed,:rsp_selling_skills,:gsb_type_installed,:location_of_gsb,:gsb_cleanliness,:installation_quality,:is_gsb_light_woring,:is_gsb_light_throw_is_good,:gsb_structured_damage,:gsb_other_problem,:gsb_retailer_feedback,:is_sis_present,:is_sis_placed_properly,:is_sis_condition_good,:is_sis_cleaned_daily,:is_sis_damaged,:is_standee_present,:store_selling_gionee,:sis_structured_flaws,:sis_security_alarm_working,:sis_security_device_charging,:sis_demo_phones_installed,:spec_card_demo_phone_match,:backwall_light_working_properly,:is_counter_lights_working,:is_clip_on_lights,:dealer_switch_on_sis_lights,:updated_gionee_creative,:sis_any_problem,:sis_retailer_feedback,:is_good_visibility_in_store,:lit_in_store,:has_a_relevant_visual,:overall_rating,:is_clipon_not_working_properly,:overall_comments,:is_audit_done,:store_open,:store_renovation,:store_shifted,:not_allowed_in_store,:user_id, :image_ids => [], :properties => [:field_id, :value, :values => []],
      :shop_audit_attributes => [
        :audit_type,
        :avg_monthly_sale,
        :most_selling_brand,
        :second_most_selling_brand, 
        :third_most_selling_brand,
        :gionee_sales,
        :gionee_stock_quantity,
        :models_available,  
        :no_of_flange,
        :flange_delivered,
        :flange_installation,
        :flange_condition,
        :flange_avilable,
        :no_of_lit_standee,
        :lit_standee_delivered,
        :lit_standee_installation,
        :lit_standee_condition,
        :lit_standee_available,
        :no_of_leaflet,
        :leaflet_delivered,
        :leaflet_installation,
        :no_of_brochure,
        :brochure_delivered,
        :brochure_installation,
        :no_of_dangler,
        :dangler_delivered,
        :dangler_installation,
        :no_of_shelf_strip,
        :shelf_strip_delivered,
        :shelf_strip_installation,
        :no_of_sticker,
        :sticker_delivered,
        :sticker_installation,
        :no_of_poster,
        :poster_delivered,
        :poster_installation,
        :no_of_demo,
        :demo_delivered,
        :demo_installation,
        :demo_condition,
        :demo_available,
        :no_of_dummy,
        :dummy_delivered,
        :dummy_installation,
        :dummy_condition,
        :dummy_available,
        :no_of_spec_card,
        :spec_card_delivered,
        :spec_card_installation,
        :no_of_cables,
        :cables_delivered,
        :cables_installation,
        :no_of_pods,
        :pods_delivered,
        :pods_installation,
        :no_of_security_system,
        :security_system_delivered,
        :security_system_installation,
        :no_of_countertop,
        :countertop_delivered,
        :countertop_installation,
        :countertop_condition,
        :countertop_available,
        :no_of_gift_item,
        :gift_item_delivered,
        :gift_item_installation,
        :no_of_tshirt,
        :tshirt_delivered,
        :tshirt_installation,
        :no_of_rollupstandee,
        :rollupstandee_delivered,
        :rollupstandee_installation,
        :no_of_clipon,
        :clipon_delivered,
        :clipon_installation,
        :clipon_condition,
        :clipon_available,
        :no_of_cubes,
        :cubes_delivered,
        :cubes_installation,
        :no_of_balloons,
        :balloons_delivered,
        :balloons_installation,
        :gsb_present,
        :sis_present, 
        :lit_standee_present, 
        :flange_present,
        :countertop_present, 
        :clipon_present, 
        :changed_visual_gsb, 
        :changed_visual_sis,
        :changed_visual_lit_standee, 
        :changed_visual_flange, 
        :changed_visual_countertop,
        :changed_visual_clipon,
        :cleaned_and_checked_gsb ,
        :cleaned_and_checked_sis, 
        :cleaned_and_checked_lit_standee,
        :cleaned_and_checked_flange,
        :cleaned_and_checked_countertop,
        :cleaned_and_checked_clipon,
        :maintenance_done_on,
        :consumnables_used,
        :type_of_issue,
        :maintenance_done,
        :problem_solved,
        :checkbox_escalate,
        :sis_present_in_store,
        :sis_type,
        :back_wall_nos,
        :glass_counter_no,
        :experience_counter_no,
        :sis_condition,
        :sis_needs,
        :no_of_gsb,
        :gsb_type_installed,
        :gsb_type_logo,
        :gsb_position,
        :gsb_condition,
        :gsb_size,
        :gsb_present_at_store,
        :dummy_models,
        :clipon_models,
        :lit_standee_models,
        :countertop_models,
        :demo_models
      ]
      )
  end

  def find_request
    @request = Request.where(:id => params[:id]).first
    unless @request
      redirect_to requests_path
    end
  end
end
