class ScreenSerializer < ActiveModel::Serializer
  attributes :id, :layout, :is_start_screen, :is_menu

  def layout
    object.is_menu? ? object.menu_layout(app_id) : object.layout
  end

  def app_id
    scope[:app_id]
  end
end
