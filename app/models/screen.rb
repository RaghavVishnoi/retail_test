class Screen < ActiveRecord::Base
  serialize :layout, Hash

  belongs_to :module_group

  before_save :ensure_only_one_start_screen

  def self.active
    joins(:module_group).where(:module_groups => { :active => true })
  end

  def menu_layout
    active_modules = ModuleGroup.active.pluck(:id)
    layout[:layout_elements].each do |k, v|
      elements = v[:layout_element][:elements]
      if elements
        elements.select! do |k, v|
          v[:ui_element] ? active_modules.include?(v[:ui_element][:module_group].to_i) : true
        end
      end
    end
    layout
  end

  private
    def ensure_only_one_start_screen
      if is_start_screen_changed? && is_start_screen?
        Screen.update_all(:is_start_screen => false)
      end
    end
end