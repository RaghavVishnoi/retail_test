class AddPoNumberIntoRequestAssignments < ActiveRecord::Migration
  def change
  	add_column :request_assignments,:po_number,:string
  end
end
