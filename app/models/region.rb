class Region < ActiveRecord::Base
  include Fields
  
  has_and_belongs_to_many :users
  
  validates :name, :presence => true
end