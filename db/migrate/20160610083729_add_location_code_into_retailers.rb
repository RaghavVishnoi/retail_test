class AddLocationCodeIntoRetailers < ActiveRecord::Migration
  def change
  	add_column :retailers,:location_code,:string
  end
end
