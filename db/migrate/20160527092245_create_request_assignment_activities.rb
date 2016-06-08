class CreateRequestAssignmentActivities < ActiveRecord::Migration
  def change
    create_table :request_assignment_activities do |t|
    	t.string :user_type
    	t.string :status
    	t.text :message
    	t.timestamps
    end
    add_reference :request_assignment_activities,:request_assignment,index: true,foreign_key: true
    add_reference :request_assignment_activities,:user,index: true,foreign_key: true
  end
end
