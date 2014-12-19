class JobTitle < ActiveRecord::Base
  validates :title, :presence => true
end