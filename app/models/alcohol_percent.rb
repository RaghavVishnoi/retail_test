class AlcoholPercent < ActiveRecord::Base
  has_many :items, :dependent => :restrict_with_error
  
  validates :value, :presence => true, :uniqueness => true
end