class Role < ActiveRecord::Base
  has_many :associated_roles, :dependent => :destroy
  has_many :permissions, :dependent => :destroy

  validates :name, :presence => true
end