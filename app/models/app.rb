class App < ActiveRecord::Base
  has_many :apps_module_groups, :dependent => :destroy
  
  validates :name, :presence => true
end