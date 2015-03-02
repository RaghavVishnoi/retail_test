class ModuleGroup < ActiveRecord::Base
  enum name: [:login, :items]
  has_many :screens, :dependent => :nullify

  def self.active
    where(:active => true)
  end
end