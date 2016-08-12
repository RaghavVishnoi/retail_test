class AddLatitudeAndLongitudeToRetailers < ActiveRecord::Migration
  def change
  	add_column :retailers,:latitude,:string
  	add_column :retailers,:longitude,:string
  end
end
