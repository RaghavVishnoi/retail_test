class JobTitle < ActiveRecord::Base
  has_and_belongs_to_many :user
  
  validates :title, :presence => true
end