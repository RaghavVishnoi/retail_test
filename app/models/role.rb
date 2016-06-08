class Role < ActiveRecord::Base
  has_many :associated_roles, :dependent => :destroy
  has_many :permissions, :dependent => :destroy
 
  validates :name, :presence => true

  def self.role_name(role_ids)
  	self.where(id: role_ids).pluck(:name)
  end

end