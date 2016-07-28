class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
    	t.string :state
    	t.string :city
        t.string :message
        t.date :send_date
    	t.string :status
        t.string :user_type
    end
  end
end
