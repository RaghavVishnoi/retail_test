class ScreenSerializer < ActiveModel::Serializer
  attributes :id, :layout, :is_start_screen, :is_menu

  def layout
    object.is_menu? ? object.menu_layout : object.layout
  end
end
