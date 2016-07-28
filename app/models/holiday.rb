class Holiday < ActiveRecord::Base
  validates :date, :description, :timezone, :presence => true
end