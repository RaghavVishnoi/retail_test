class AppsModuleGroup < ActiveRecord::Base
  belongs_to :app
  belongs_to :module_group
end