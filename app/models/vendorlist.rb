class Vendorlist < ActiveRecord::Base

	validates :vendor_name,:email,:status,  :presence => true


	def self.search(id)
      @vendor = Vendorlist.where("vendor_name = ? OR state = ?", id,id) 
  end

	def self.display_names

     all.map { |c| 
      if c.display_name != nil
        [c.display_name, c.id] 
      end

    }
   
  end

    def display_name
  	  if status == 'Active'
        "#{vendor_name} - #{region}  #{state}"
      end
    end

end
