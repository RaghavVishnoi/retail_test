class ModuleGroup < ActiveRecord::Base
  enum name: [:login, :items, :default, :attendance, :crm, :survey]
  has_many :screens, :dependent => :nullify

  def self.active
    where(:active => true)
  end
end