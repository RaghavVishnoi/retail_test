module ApplicationHelper
  def permission_name(subject_class, action_permission) 
    Permission::Actions[subject_class][:permissions][action_permission]
  end

  def permission_options(action_permission)
    actions = Permission::Actions.map { |k, v| [v[:group_name], v[:permissions].invert.to_a] }
    grouped_options_for_select(actions, action_permission)
  end

  def request_status_class(status)
    params[:q] && params[:q][:status] == status ? 'active' : ''
  end

  def request_type_name(request)
    if request.sis?
      "SIS"
    elsif request.gsb?
      "GSB"
    elsif request.in_shop?
      "In-shop"
    elsif request.maintenance?
      "Maintenance"
    elsif request.visitor?
      "Audit"
    end

  end

  def request_type_backend(request_type)
     if request_type == 'GSB' || request_type == 'gsb'
       0
     elsif request_type == 'SIS' || request_type == 'sis'
       1
     elsif request_type == 'InShop' || request_type == 'in_shop'
       2
     elsif request_type == 'Maintenance' || request_type == 'maintenance'
       3
     elsif request_type == 'Audit' || request_type == 'audit'
       4
     end      
         
  end

   

  def get_retailer(retailer_code)
    Retailer.find_by(:retailer_code => retailer_code)
  end

  def monthly_sales_str(amount, values)
    amount = amount.to_f
    index = 0
    values.each_with_index do |val, i| 
      index = i
      if amount < val[1].to_f 
        index = index - 1
        break
      end
    end
    index = index < 0  ? 0 : index
    v = values[index]
    return v ? v[0] : ""
  end

  def field_display_name(field)
    field ? field[:field][:display_name] : ""
  end

  def field_values_str(field)
    field ? field[:values].select(&:present?).join('/') : ""
  end

  def request_cmo(request_id)
    RequestActivity.action_user(request_id,'cmo_approved,cmo_declined')
  end

  def to_bool(result)
    case result
    when true
      'Yes'
    when false
      'No'
    end
  end

  def date(from,to)
    time = []
    if from == nil || from.length == 0 || to == nil || to.length == 0
      from = (Time.now.to_date - 1.month).beginning_of_day
      to = (Time.now.to_date).end_of_day
      time.push(from)
      time.push(to)
     else
      time.push(from)
      time.push(to)
     end
     time
  end

  def audit_type(type)
    case type
    when 1,'1'
      'Visibility Audit'
    when 2,'2'
      'Deployment'
    when 3,'3'
      'Maintenance'
    end
  end

  def vmqa_header
    [
        "id",
        "status",
        "request_type",
        "RSP_present_in_Shop?",
        "reason", 
        "CMO_name",
        "retailer_code",
        "retailer_name",
        "state",
        "city",
        "shop_address",
        "lat",
        "long",
        "remarks", 
        "approver_comment",
        "CMO_comment",
        "overall_rating",
        "submitted_date",
        "shop_visit_date",
        "shop_visit_done_by",
        "visitor_contact_number",
        "is_audit_done",
        "store_closed",
        "store_renovation",
        "store_shifted",
        "not_allowed_by_shop_owner",
        "shop_requirements",
         branding_details_header,
         "Overall comments",
          "audit_type",
          "average_monthly_sales",
          "most_selling_brand",
          "second_most_selling_brand", 
          "third_most_selling_brand",
          "gionee_sales",
          "gionee_stock_quantity",
          "models_available", 
          "no_of_flange",
          "flange_delivered",
          "flange_installation",
          "flange_condition",
          "flange_avilable",
        "no_of_lit_standee",
        "lit_standee_delivered",
        "lit_standee_installation",
        "lit_standee_condition",
        "lit_standee_available",
        "no_of_leaflet",
        "leaflet_delivered",
        "leaflet_installation",
        "no_of_brochure",
        "brochure_delivered",
        "brochure_installation",
        "no_of_dangler",
        "dangler_delivered",
        "dangler_installation",
        "no_of_shelf_strip",
        "shelf_strip_delivered",
        "shelf_strip_installation",
        "no_of_sticker",
        "sticker_delivered",
        "sticker_installation",
        "no_of_poster",
        "poster_delivered",
        "poster_installation",
        "no_of_demo",
        "demo_delivered",
        "demo_installation",
        "demo_condition",
        "demo_available",
        "no_of_dummy",
        "dummy_delivered",
        "dummy_installation",
        "dummy_condition",
        "dummy_available",
        "no_of_spec_card",
        "spec_card_delivered",
        "spec_card_installation",
        "no_of_cables",
        "cables_delivered",
        "cables_installation",
        "no_of_pods",
        "pods_delivered",
        "pods_installation",
        "no_of_security_system",
        "security_system_delivered",
        "security_system_installation",
        "no_of_countertop",
        "countertop_delivered",
        "countertop_installation",
        "countertop_condition",
        "countertop_available",
        "no_of_gift_item",
        "gift_item_delivered",
        "gift_item_installation",
        "no_of_tshirt",
        "tshirt_delivered",
        "tshirt_installation",
        "no_of_rollupstandee",
        "rollupstandee_delivered",
        "rollupstandee_installation",
        "no_of_clipon",
        "clipon_delivered",
        "clipon_installation",
        "clipon_condition",
        "clipon_available",
        "no_of_cubes",
        "cubes_delivered",
        "cubes_installation",
        "no_of_balloons",
        "balloons_delivered",
        "balloons_installation",
        "gsb_present",
        "sis_present", 
        "lit_standee_present",
        "flange_present",
        "countertop_present", 
        "clipon_present",
        "changed_visual_gsb",
        "changed_visual_sis",
        "changed_visual_lit_standee",
         "changed_visual_flange",
         "changed_visual_countertop",
        "changed_visual_clipon",
        "cleaned_and_checked_gsb ",
        "cleaned_and_checked_sis",
        "cleaned_and_checked_lit_standee",
        "cleaned_and_checked_flange",
        "cleaned_and_checked_countertop",
        "cleaned_and_checked_clipon",
        "maintenance_done_on",
        "consumnables_used",
        "type_of_issue",
        "maintenance_done",
        "problem_solved",
        "checkbox_escalate",
        "sis_present_in_store",
        "sis_type",
        "back_wall_nos",
        "glass_counter_no",
        "experience_counter_no",
        "sis_condition",
        "sis_needs",
        "no_of_gsb",
        "gsb_type_installed",
        "gsb_type_logo",
        "gsb_position",
        "gsb_condition",
        "gsb_size",
        "gsb_present_at_store",
        "dummy_models",
        "clipon_models",
        "lit_standee_models",
        "countertop_models",
        "demo_models",
        "range_brochure_avilable",
        "leaflet_available",
        "poster_available",
        "wall_branding_available",
        "one_way_vision_available",
        "danglers_available",
        "shelf_strips_available",
        "roll_up_standee_available",
        "no_of_range_brochure",
        "range_brochure_type",
        "leaflet_type",
        "poster_type",
        "no_of_wall_branding",
        "wall_branding_type",
        "no_of_one_way_vision",
        "one_way_vision_type",
        "no_of_danglers",
        "danglers_type",
        "no_of_shelf_strips",
        "shelf_strips_type",
        "no_of_roll_up_standee",
        "roll_up_standee_type",
        "escalate_to_tl",
        "cleaned_and_checked_clipon",
        "sis_type_logo",
        "dummy_models",
        "demo_models",
        "posters_models",
        "sticker_models",
        "brochure_models",
        "leaflet_models",
        "lit_standee_models"
        ].flatten.map{|head| head.camelize}.join(',')
  end

  def branding_details_header
    Request.new.branding_details.map { |r| r[:field][:display_name] }
  end

  def vmqa_records(request)
    if request.shop_audit != nil
      lat = images.first.lat if images.first != nil
      long = images.first.long if images.first != nil 
      shop_audit = request.shop_audit
      [request.id,request.status, request_type_name(request),request.is_rsp, request.rsp_not_present_reason, if request.status != 'cmo_pending' then request_cmo(request.id) else State.find(request.state_id).name+"'s CMOs" end, request.retailer_code,request.shop_name,request.state,request.city,request.shop_address ,lat,long,request.remarks, request.comment_by_approver, request.comment_by_cmo,request.overall_rating, 
         request.created_at.strftime("%b %d, %Y"),request.shop_visit_date,request.shop_visit_done_by,request.visitor_contact_number,request.is_audit_done,request.store_open,request.store_renovation,request.store_shifted,request.not_allowed_in_store,field_values_str(request.shop_requirements),branding_details_csv(request),request.overall_comments,
          audit_type(shop_audit.audit_type),
          request.average_monthly_sales,
          request.most_selling_brand,
          request.second_most_selling_brand, 
          request.third_most_selling_brand,
          request.gionee_sales,
          request.gionee_stock_quantity,
          request.models_available, 
          shop_audit.no_of_flange,
          shop_audit.flange_delivered,
          shop_audit.flange_installation,
          shop_audit.flange_condition,
          shop_audit.flange_avilable,
          shop_audit.no_of_lit_standee,
          shop_audit.lit_standee_delivered,
          shop_audit.lit_standee_installation,
          shop_audit.lit_standee_condition,
          shop_audit.lit_standee_available,
          shop_audit.no_of_leaflet,
          shop_audit.leaflet_delivered,
          shop_audit.leaflet_installation,
          shop_audit.no_of_brochure,
          shop_audit.brochure_delivered,
          shop_audit.brochure_installation,
          shop_audit.no_of_dangler,
          shop_audit.dangler_delivered,
          shop_audit.dangler_installation,
          shop_audit.no_of_shelf_strip,
          shop_audit.shelf_strip_delivered,
          shop_audit.shelf_strip_installation,
          shop_audit.no_of_sticker,
          shop_audit.sticker_delivered,
          shop_audit.sticker_installation,
          shop_audit.no_of_poster,
          shop_audit.poster_delivered,
          shop_audit.poster_installation,
          shop_audit.no_of_demo,
          shop_audit.demo_delivered,
          shop_audit.demo_installation,
          shop_audit.demo_condition,
          shop_audit.demo_available,
          shop_audit.no_of_dummy,
          shop_audit.dummy_delivered,
          shop_audit.dummy_installation,
          shop_audit.dummy_condition,
          shop_audit.dummy_available,
          shop_audit.no_of_spec_card,
          shop_audit.spec_card_delivered,
          shop_audit.spec_card_installation,
          shop_audit.no_of_cables,
          shop_audit.cables_delivered,
          shop_audit.cables_installation,
          shop_audit.no_of_pods,
          shop_audit.pods_delivered,
          shop_audit.pods_installation,
          shop_audit.no_of_security_system,
          shop_audit.security_system_delivered,
          shop_audit.security_system_installation,
          shop_audit.no_of_countertop,
          shop_audit.countertop_delivered,
          shop_audit.countertop_installation,
          shop_audit.countertop_condition,
          shop_audit.countertop_available,
          shop_audit.no_of_gift_item,
          shop_audit.gift_item_delivered,
          shop_audit.gift_item_installation,
          shop_audit.no_of_tshirt,
          shop_audit.tshirt_delivered,
          shop_audit.tshirt_installation,
          shop_audit.no_of_rollupstandee,
          shop_audit.rollupstandee_delivered,
          shop_audit.rollupstandee_installation,
          shop_audit.no_of_clipon,
          shop_audit.clipon_delivered,
          shop_audit.clipon_installation,
          shop_audit.clipon_condition,
          shop_audit.clipon_available,
          shop_audit.no_of_cubes,
          shop_audit.cubes_delivered,
          shop_audit.cubes_installation,
          shop_audit.no_of_balloons,
          shop_audit.balloons_delivered,
          shop_audit.balloons_installation,
          shop_audit.gsb_present,
          shop_audit.sis_present, 
          shop_audit.lit_standee_present,
          shop_audit.flange_present,
          shop_audit.countertop_present, 
          shop_audit.clipon_present,
          shop_audit.changed_visual_gsb,
          shop_audit.changed_visual_sis,
          shop_audit.changed_visual_lit_standee,
          shop_audit.changed_visual_flange,
          shop_audit.changed_visual_countertop,
          shop_audit.changed_visual_clipon,
          shop_audit.cleaned_and_checked_gsb ,
          shop_audit.cleaned_and_checked_sis,
          shop_audit.cleaned_and_checked_lit_standee,
          shop_audit.cleaned_and_checked_flange,
          shop_audit.cleaned_and_checked_countertop,
          shop_audit.cleaned_and_checked_clipon,
          shop_audit.maintenance_done_on,
          shop_audit.consumnables_used,
          shop_audit.type_of_issue,
          shop_audit.maintenance_done,
          shop_audit.problem_solved,
          shop_audit.checkbox_escalate,
          shop_audit.sis_present_in_store,
          shop_audit.sis_type,
          shop_audit.back_wall_nos,
          shop_audit.glass_counter_no,
          shop_audit.experience_counter_no,
          shop_audit.sis_condition,
          shop_audit.sis_needs,
          shop_audit.no_of_gsb,
          shop_audit.gsb_type_installed,
          shop_audit.gsb_type_logo,
          shop_audit.gsb_position,
          shop_audit.gsb_condition,
          shop_audit.gsb_size,
          shop_audit.gsb_present_at_store,
          shop_audit.dummy_models,
          shop_audit.clipon_models,
          shop_audit.lit_standee_models,
          shop_audit.countertop_models,
          shop_audit.demo_models,
          shop_audit.range_brochure_avilable,
          shop_audit.leaflet_available,
          shop_audit.poster_available,
          shop_audit.wall_branding_available,
          shop_audit.one_way_vision_available,
          shop_audit.danglers_available,
          shop_audit.shelf_strips_available,
          shop_audit.roll_up_standee_available,
          shop_audit.no_of_range_brochure,
          shop_audit.range_brochure_type,
          shop_audit.leaflet_type,
          shop_audit.poster_type,
          shop_audit.no_of_wall_branding,
          shop_audit.wall_branding_type,
          shop_audit.no_of_one_way_vision,
          shop_audit.one_way_vision_type,
          shop_audit.no_of_danglers,
          shop_audit.danglers_type,
          shop_audit.no_of_shelf_strips,
          shop_audit.shelf_strips_type,
          shop_audit.no_of_roll_up_standee,
          shop_audit.roll_up_standee_type,
          shop_audit.escalate,
          shop_audit.cleaned_and_checked_clipon,
          shop_audit.sis_type_logo,
          shop_audit.dummy_models,
          shop_audit.demo_models,
          shop_audit.posters_models,
          shop_audit.sticker_models,
          shop_audit.brochure_models,
          shop_audit.leaflet_models,
          shop_audit.lit_standee_models].map{|data| data == true ? "Yes" : data == false ? "No" : data}
    end
  end

  def audit_request(type)
    case type
    when 1
      "Audit Only"
    when 3
      "Maintenance"
    when 2
      "Deployment"
    end
  end

  

end