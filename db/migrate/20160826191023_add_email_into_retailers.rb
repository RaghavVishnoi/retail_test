class AddEmailIntoRetailers < ActiveRecord::Migration
  def change
  	add_column :retailers,:email,:string
  end
end
