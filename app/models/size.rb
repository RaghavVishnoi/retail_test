class Size < ActiveRecord::Base
  has_many :items, :dependent => :restrict_with_error
  
  validates :name, :presence => true, :uniqueness => true
end