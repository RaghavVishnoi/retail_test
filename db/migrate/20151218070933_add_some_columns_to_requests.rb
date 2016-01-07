class AddSomeColumnsToRequests < ActiveRecord::Migration
  def change
  	add_column :requests,:is_other,:integer
  	add_column :requests,:is_lfr,:integer
  end
end
