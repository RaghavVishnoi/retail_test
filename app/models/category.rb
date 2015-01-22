class Category < ActiveRecord::Base
  has_many :items, :dependent => :restrict_with_error
  has_many :subcategory_items, :class_name => "Item", :foreign_key => "subcategory_id", :dependent => :restrict_with_error
  
  validates :name, :presence => true, :uniqueness => true
end