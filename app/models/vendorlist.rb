class Vendorlist < ActiveRecord::Base

	validates :vendor_name,:status,  :presence => true

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :email,presence: true,length:
             {minimum: 6,maximum: 25 },
             uniqueness: true,
             format: {with: VALID_EMAIL_REGEX}

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
