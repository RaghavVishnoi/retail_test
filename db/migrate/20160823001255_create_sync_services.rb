class CreateSyncServices < ActiveRecord::Migration
  def change
    create_table :sync_services do |t|
    	t.string :name
    	t.text   :url
    	t.datetime :sync_time
    	t.datetime :start_time
    	t.datetime :end_time
    	t.integer  :sync_count
    	t.timestamps
    end
  end
end
