class AddColumnIsFixedIntoRequests < ActiveRecord::Migration
  def change
  	add_column :requests,:is_fixed,:integer,default: 0
  end
end
