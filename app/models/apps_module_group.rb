class AppsModuleGroup < ActiveRecord::Base
  belongs_to :app
  belongs_to :module_group
  has_many :screens, :through => :module_group

  after_save :update_screens

  private
    def update_screens
      screens.update_all(:updated_at => Time.current)
    end
end