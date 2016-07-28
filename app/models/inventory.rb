class Inventory < ActiveRecord::Base
  belongs_to :item
  belongs_to :warehouse

  validates :quantity, :presence => true
end