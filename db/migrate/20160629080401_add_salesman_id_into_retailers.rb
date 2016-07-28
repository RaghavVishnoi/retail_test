class AddSalesmanIdIntoRetailers < ActiveRecord::Migration
  def change
  	add_column :retailers,:salesman_id,:string
  end
end