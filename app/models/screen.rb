class Screen < ActiveRecord::Base
  MENU_ELEMENT_IDS = { 'login' => "0", 'items' => "1" }

  serialize :layout, Hash

  belongs_to :module_group

  before_save :ensure_only_one_start_screen

  def self.active
    joins(:module_group).where(:module_groups => { :active => true })
  end

  def self.menu_element_ids
    MENU_ELEMENT_IDS.values_at(ModuleGroup.active.map(&:name)).compact
  end

  private
    def ensure_only_one_start_screen
      if is_start_screen?
        Screen.update_all(:is_start_screen => false)
      end
    end
end