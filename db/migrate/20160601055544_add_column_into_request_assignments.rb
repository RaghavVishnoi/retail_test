class AddColumnIntoRequestAssignments < ActiveRecord::Migration
  def change
  	add_column :request_assignments,:upload_bill,:integer,default: 0
  end
end
