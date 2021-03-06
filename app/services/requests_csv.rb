class RequestsCsv
  attr_accessor :from_date, :till_date
  include ApplicationHelper
   


  def initialize(from, till, request_type,current_user)
    @from_date = Time.zone.parse(from) || Time.current
    @till_date = Time.zone.parse(till) || Time.current
    @from_date = @from_date.beginning_of_day
    @till_date = @till_date.end_of_day
    @request_type = request_type.strip
    @current_user = current_user
    @user_id = current_user.id
    @role =  Request.user_role(current_user.id)
    @states = State.states(current_user)
  end

  def self.absolute_file_path(file_name)
    file_name = file_name+"_#{@request_type}"
    File.join("#{Rails.root}/requests_csv", file_name) + '.csv'
  end

  def target_file_name
    "#{from_date.to_date.to_s}_#{till_date.to_date.to_s}_#{@request_type}"
  end


  def target_file_path
   self.class.absolute_file_path target_file_name
  end

  def file_name
    @file_name ||= "#{Time.current.to_i}"
  end

  def file_path
    self.class.absolute_file_path file_name
  end

  def file
    @file ||= File.new file_path, "w+"
  end

  def generate
    create_csv_file
    send_csv
  end

  def generate_without_delay
    create_csv_file
    send_without_delay
  end

  def write_file text
      file.puts text
  end

  # def branding_details_header
  #   Request.new.branding_details.map { |r| r[:field][:display_name] }
  # end

  def branding_details_csv(request)
    request.branding_details.map { |details| field_values_str(details) }
  end

  def header
      if @request_type == 'All' || @request_type == 'all' || @request_type == '' || @request_type == nil
      [ 'Id','status', 'Request type', 'RSP Present in Shop?', 'Reason', 'CMO Name', 'Retailer Code', 'RSP Name', 'RSP Mobile number', 'RSP sales tag app user ID', 
        'City', 'state', 'Shop Name', 'Shop Address','Lat','Long', 'Shop Owner Name', 'Shop Owner Phone', 'Avg. Store Monthly Sales',
        'Avg. Gionee Monthly Sales', 'Space Available in Store', 'Gionee GSB Present?', 'Type of SIS required?',
        'Is Gionee SIS installed in shop?', 'Is it main signage?', 'GSB installed outside?', 'Width', 'Height',
        'Type of GSB Requested?', 'Shop Requirements', branding_details_header, 'Remarks', 'Approver Comment','CMO Comment','Submitted date','Type of Issue','Type of Problem',
        'Shop Visit Date','Shop Visit Done By','Is Standee Present','Visitor Contact Number','Is Audit Done','Store Closed','Store Renovation','Store Shifted','Not Allowed By Shop Owner','Store Selling Gionee','Is Clipon Present','Is Countertop Present','Is Leaflets Available','Number of peace in stock',
        'Is wallposter in shop','Is dangler in shop','RSP assigned in store','RSP present in shop','RSP in gionee t-shirt','RSP well groomed','RSP selling skills','GSB type installed',
        'Location of GSB','GSB cleanliness','Installation quality','Is GSB light working','IS GSB light throw is good','GSB structured damaged','GSB other problem','GSB retailer feedback',
        'Is SIS present','Is SIS placed properly','Is SIS condition good','Is SIS cleaned daily','Is SIS damaged','SIS structured flaws','SIS security alarm working','SIS security device chargin',
        'SIS demo phone installed','Spec card demo phone match','Backwall light working properly','Is counter lights working','Is clipon on light','Dealer switch on SIS lights','Update Gionee creative','SIS any problem',
        'SIS retailer feedback','Is good visibility in store','Lit in store','Has a relevant visual','Overall rating','Is clipon not working properly','Overall comments'
      ].flatten.join(',')

     elsif @request_type == 'gsb' || @request_type == 'sis' || @request_type == 'in_shop'
       [ 'Id','status', 'Request type', 'RSP Present in Shop?', 'Reason', 'CMO Name', 'Retailer Code', 'RSP Name', 'RSP Mobile number', 'RSP sales tag app user ID', 
        'City', 'state', 'Shop Name', 'Shop Address','Lat','Long', 'Shop Owner Name', 'Shop Owner Phone', 'Avg. Store Monthly Sales',
        'Avg. Gionee Monthly Sales', 'Space Available in Store', 'Gionee GSB Present?', 'Type of SIS required?',
        'Is Gionee SIS installed in shop?', 'Is it main signage?', 'GSB installed outside?', 'Width', 'Height',
        'Type of GSB Requested?', 'Shop Requirements', branding_details_header, 'Remarks', 'Approver Comment','CMO Comment','Submitted date'
      ].flatten.join(',')
     elsif @request_type == 'maintenance'
      [ 'Id','status', 'Request type', 'RSP Present in Shop?', 'Reason', 'CMO Name', 'Retailer Code', 
         'City','State','Shop Name','Shop Address','Lat','Long','Retailer Name','Retailer Mobile Number','Remarks', 'Approver Comment','CMO Comment','Submitted date','Type of Issue','Type of Problem'
      ].flatten.join(',')
     elsif @request_type == 'audit'
      [ 'Id','status', 'Request type', 'RSP Present in Shop?', 'Reason', 'CMO Name', 'Retailer Code','State','City','Shop Address','Lat','Long','Remarks', 'Approver Comment','CMO Comment','Submitted date','Shop Visit Date',
        'Shop Visit Done By','Is Standee Present','Visitor Contact Number','Is Audit Done','Store Closed','Store Renovation','Store Shifted','Not Allowed By Shop Owner','Store Selling Gionee','Is Clipon Present','Is Countertop Present','Is Leaflets Available','Number of peace in stock',
        'Is wallposter in shop','Is dangler in shop','RSP assigned in store','RSP present in shop','RSP in gionee t-shirt','RSP well groomed','RSP selling skills','GSB type installed',
        'Location of GSB','GSB cleanliness','Installation quality','Is GSB light working','IS GSB light throw is good','GSB structured damaged','GSB other problem','GSB retailer feedback',
        'Is SIS present','Is SIS placed properly','Is SIS condition good','Is SIS cleaned daily','Is SIS damaged','SIS structured flaws','SIS security alarm working','SIS security device chargin',
        'SIS demo phone installed','Spec card demo phone match','Backwall light working properly','Is counter lights working','Is clipon on light','Dealer switch on SIS lights','Update Gionee creative','SIS any problem',
        'SIS retailer feedback','Is good visibility in store','Lit in store','Has a relevant visual','Overall rating','Is clipon not working properly','Shop Requirements', branding_details_header,'Overall comments'].flatten.join(',')
      elsif @request_type == 'vmqa'
          vmqa_header
     end
        
         
  end


  def create_csv_file
   write_file header
   if @request_type == 'All' || @request_type == 'all' || @request_type == '' || @request_type == nil
        Request.where(:created_at => from_date..till_date,state_id: @states).find_each(batch_size: 1000) do |request|
          write_file to_csv(request)
        end  
    elsif @request_type == 'vmqa'
      Request.where(request_type: 4,:created_at => from_date..till_date,state_id: @states).joins(:shop_audit).find_each(batch_size: 100) do |request|
            write_file to_csv(request)
      end
   else
      request_type = request_type_backend(@request_type)
      Request.where(:request_type => request_type,:created_at => from_date..till_date,state_id: @states).find_each(batch_size: 1000) do |request|
        write_file to_csv(request)
      end
   end   
      file.close
      File.rename(file_path, target_file_path)
  end

  def to_csv(request)
      image = request.images.first
      if image != nil
        @lat = image.lat
        @long = image.long
      else
        @lat = 0.0
        @long = 0.0
      end 
     
      if @request_type == 'All' || @request_type == 'all' || @request_type == '' || @request_type == nil
        [ request.id,request.status, request_type_name(request),request.is_rsp, request.rsp_not_present_reason, if request.status != 'cmo_pending' then request_cmo(request.id) else State.find(request.state_id).name+"'s CMOs" end, request.retailer_code, request.rsp_name,
        request.rsp_mobile_number, request.rsp_app_user_id,request.city, request.state, request.shop_name, request.shop_address,@lat,@long,
        request.shop_owner_name, request.shop_owner_phone, monthly_sales_str(request.avg_store_monthly_sales, AVG_STORE_MONTHLY_SALES), monthly_sales_str(request.avg_gionee_monthly_sales, AVG_GIONEE_MONTHLY_SALES),
        request.space_available, request.is_gionee_gsb_present, request.type_of_sis_required, request.is_sis_installed, request.is_main_signage,
        request.is_gsb_installed_outside, request.width, request.height, request.type_of_gsb_requested, field_values_str(request.shop_requirements),
        branding_details_csv(request), request.remarks, request.comment_by_approver,request.comment_by_cmo,  request.created_at.strftime("%b %d, %Y"),request.type_of_issue,request.type_of_problem,
        request.shop_visit_date,request.shop_visit_done_by,request.is_standee_present,request.visitor_contact_number,request.is_audit_done,request.store_open,request.store_renovation,request.store_shifted,request.not_allowed_in_store,request.store_selling_gionee,request.is_clipon_present,request.is_countertop_present,request.is_leaflets_available,
        request.no_of_peace_in_stock,request.is_wall_poster_in_shop,request.is_dangler_in_shop,request.rsp_assigned_in_store,request.rsp_present_in_shop,request.rsp_in_gionee_tshirt,request.rsp_well_groomed,request.rsp_selling_skills,request.gsb_type_installed,request.location_of_gsb,
        request.gsb_cleanliness,request.installation_quality,request.is_gsb_light_woring,request.is_gsb_light_throw_is_good,request.gsb_structured_damage,request.gsb_other_problem,request.gsb_retailer_feedback,request.is_sis_present,request.is_sis_placed_properly,request.is_sis_condition_good,
        request.is_sis_cleaned_daily,request.is_sis_damaged,request.sis_structured_flaws,request.sis_security_alarm_working,request.sis_security_device_charging,request.sis_demo_phones_installed,request.spec_card_demo_phone_match,request.backwall_light_working_properly,
        request.is_counter_lights_working,request.is_clip_on_lights,request.dealer_switch_on_sis_lights,request.updated_gionee_creative,request.sis_any_problem,request.sis_retailer_feedback,request.is_good_visibility_in_store,request.lit_in_store,request.has_a_relevant_visual,
        request.overall_rating,request.is_clipon_not_working_properly,request.overall_comments
        ].flatten.map {|v| "\"#{v.to_s.gsub('"', '""')}\"" }.join(',')

       elsif @request_type == 'gsb' || @request_type == 'sis' || @request_type == 'in_shop'
        [ request.id,request.status, request_type_name(request),request.is_rsp, request.rsp_not_present_reason,  if request.status != 'cmo_pending' then request_cmo(request.id) else State.find(request.state_id).name+"'s CMOs" end, request.retailer_code, request.rsp_name,
        request.rsp_mobile_number, request.rsp_app_user_id,request.city, request.state, request.shop_name, request.shop_address,@lat,@long,
        request.shop_owner_name, request.shop_owner_phone, monthly_sales_str(request.avg_store_monthly_sales, AVG_STORE_MONTHLY_SALES), monthly_sales_str(request.avg_gionee_monthly_sales, AVG_GIONEE_MONTHLY_SALES),
        request.space_available, request.is_gionee_gsb_present, request.type_of_sis_required, request.is_sis_installed, request.is_main_signage,
        request.is_gsb_installed_outside, request.width, request.height, request.type_of_gsb_requested, field_values_str(request.shop_requirements),
        branding_details_csv(request), request.remarks, request.comment_by_approver, request.comment_by_cmo,  request.created_at.strftime("%b %d, %Y")
        ].flatten.map {|v| "\"#{v.to_s.gsub('"', '""')}\"" }.join(',')

       elsif @request_type == 'maintenance'
        [ request.id,request.status, request_type_name(request),request.is_rsp, request.rsp_not_present_reason,  if request.status != 'cmo_pending' then request_cmo(request.id) else State.find(request.state_id).name+"'s CMOs" end, request.retailer_code,request.city, request.state, request.shop_name, request.shop_address,@lat,@long,
        request.shop_owner_name, request.shop_owner_phone, request.remarks, request.comment_by_approver, request.comment_by_cmo, 
         request.created_at.strftime("%b %d, %Y"),request.type_of_issue,request.type_of_problem
        ].flatten.map {|v| "\"#{v.to_s.gsub('"', '""')}\"" }.join(',')

       elsif @request_type == 'audit'
       [ request.id,request.status, request_type_name(request),request.is_rsp, request.rsp_not_present_reason, if request.status != 'cmo_pending' then request_cmo(request.id) else State.find(request.state_id).name+"'s CMOs" end, request.retailer_code,request.state,request.city,request.shop_address ,@lat,@long,request.remarks, request.comment_by_approver, request.comment_by_cmo, 
         request.created_at.strftime("%b %d, %Y"),request.shop_visit_date,request.shop_visit_done_by,request.is_standee_present,request.visitor_contact_number,request.is_audit_done,request.store_open,request.store_renovation,request.store_shifted,request.not_allowed_in_store,request.store_selling_gionee,request.is_clipon_present,request.is_countertop_present,request.is_leaflets_available,
         request.no_of_peace_in_stock,request.is_wall_poster_in_shop,request.is_dangler_in_shop,request.rsp_assigned_in_store,request.rsp_present_in_shop,request.rsp_in_gionee_tshirt,request.rsp_well_groomed,request.rsp_selling_skills,request.gsb_type_installed,request.location_of_gsb,
         request.gsb_cleanliness,request.installation_quality,request.is_gsb_light_woring,request.is_gsb_light_throw_is_good,request.gsb_structured_damage,request.gsb_other_problem,request.gsb_retailer_feedback,request.is_sis_present,request.is_sis_placed_properly,request.is_sis_condition_good,
         request.is_sis_cleaned_daily,request.is_sis_damaged,request.sis_structured_flaws,request.sis_security_alarm_working,request.sis_security_device_charging,request.sis_demo_phones_installed,request.spec_card_demo_phone_match,request.backwall_light_working_properly,
         request.is_counter_lights_working,request.is_clip_on_lights,request.dealer_switch_on_sis_lights,request.updated_gionee_creative,request.sis_any_problem,request.sis_retailer_feedback,request.is_good_visibility_in_store,request.lit_in_store,request.has_a_relevant_visual,
         request.overall_rating,request.is_clipon_not_working_properly,field_values_str(request.shop_requirements),branding_details_csv(request),request.overall_comments
        ].flatten.map {|v| "\"#{v.to_s.gsub('"', '""')}\"" }.join(',')
          
       elsif @request_type == 'vmqa'
        [vmqa_records(request)].flatten.map {|v| "\"#{v.to_s.gsub('"', '""')}\"" }.join(',')
         
       end
      
    
  end

  def send_csv
    subject = @request_type.upcase+" Report from "+@from_date.to_date.strftime("%d %b,%Y")+" to "+@till_date.to_date.strftime("%d %b,%Y")
    RequestMailer.delay.csv_mail(@current_user.email, target_file_name,subject)
  end

  def send_without_delay
    subject = @request_type.upcase+" Report from "+@from_date.to_date.strftime("%d %b,%Y")+" to "+@till_date.to_date.strftime("%d %b,%Y")
    RequestMailer.csv_mail(@current_user.email, target_file_name,subject).deliver!
  end
end