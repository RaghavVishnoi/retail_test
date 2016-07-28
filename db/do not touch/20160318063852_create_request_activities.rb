class CreateRequestActivities < ActiveRecord::Migration
  def change
    create_table :request_activities do |t|
    	t.integer :request_id
    	t.string :request_states
    	t.integer :user_id
    	t.string :user_type
    	t.string :comment
    	t.string :activity_date
    	t.timestamps
    end 
    add_index :request_activities,:request_id
    add_index :request_activities,:user_id
  end
end
