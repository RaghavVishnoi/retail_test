class Screen < ActiveRecord::Base
  serialize :layout, Hash

  belongs_to :module_group
  has_many :apps_module_groups, :through => :module_group

  before_save :ensure_only_one_start_screen

  def self.active(app_id)
    joins(:apps_module_groups).where(:apps_module_groups => { :app_id => app_id })
  end

  def menu_layout(app_id)
    active_modules = ModuleGroup.active(app_id).pluck(:id)
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