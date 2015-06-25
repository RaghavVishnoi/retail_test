class Retailer < ActiveRecord::Base
	 
	validate :retailer_state, :presence => true
	validate :retailer_city, :presence => true

def self.display_names
	
    all.map { |c| [c.display_name, c.id] }

  end

  def display_name

    name = Retailer.select(:state).uniq

     
  end
	 
end
