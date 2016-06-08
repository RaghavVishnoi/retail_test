class CreateRequestAssignments < ActiveRecord::Migration
  def change
    create_table :request_assignments do |t|
        t.integer :user_id
		t.integer :request_id
		t.datetime :assign_date
		t.string :current_stage
		t.string :status
		t.string :user_type
		t.timestamps	
	end
  end
end
