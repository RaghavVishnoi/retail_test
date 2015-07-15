class AddColForMaintenanceIn < ActiveRecord::Migration
  def change
  	add_column :requests,:maintenance_requestor,:string
  	add_column :requests,:maintenance_requestor_mobile_number,:string
  	add_column :requests,:type_of_issue,:string
  	add_column :requests,:type_of_problem,:string
  	 

  end
end
