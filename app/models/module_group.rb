class ModuleGroup < ActiveRecord::Base
  enum name: [:login, :items, :default, :attendance, :crm, :survey, :requester,:vendor,:testing]
  has_many :screens, :dependent => :nullify
  has_many :apps_module_groups, :dependent => :destroy
  has_many :apps, :through => :apps_module_groups

  def self.active(app_id)
    joins(:apps_module_groups).where(:apps_module_groups => { :app_id => app_id }).uniq
  end
end