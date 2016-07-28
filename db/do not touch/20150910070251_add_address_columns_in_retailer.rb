class AddAddressColumnsInRetailer < ActiveRecord::Migration
  def change
  	add_column :retailers, :address, :string
  	
  end
end
