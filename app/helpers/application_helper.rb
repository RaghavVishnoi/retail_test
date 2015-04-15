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
    end
  end
end