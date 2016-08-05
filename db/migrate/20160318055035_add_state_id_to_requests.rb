class AddStateIdToRequests < ActiveRecord::Migration
  def change
  	  	add_column :requests,:state_id,:integer
  end
end
