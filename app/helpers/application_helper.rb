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

end