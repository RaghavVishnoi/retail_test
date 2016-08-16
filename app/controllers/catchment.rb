class Catchment < ActiveRecord::Base
	belongs_to :sales_order
	has_many :catchment_business_shops

	accepts_nested_attributes_for :catchment_business_shops , :allow_destroy => true

end
