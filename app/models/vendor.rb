class Vendor < ActiveRecord::Base

	validates :region,:state,:vendor_name,:contact_person,:email,  :presence => true

	

end