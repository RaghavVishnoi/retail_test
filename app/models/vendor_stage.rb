class VendorStage < ActiveRecord::Base
	belongs_to :vendor_requests
	belongs_to :vendor_assignments
	
end
