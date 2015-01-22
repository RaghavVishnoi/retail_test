class Size < ActiveRecord::Base
  validates :name, :presence => true, :uniqueness => true
end