class Vendorlist < ActiveRecord::Base

	def self.display_names
    all.map { |c| [c.display_name, c.id] }
  end

  def display_name
    "#{vendor_name} - #{region}  #{state}"
  end

end
