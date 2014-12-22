class CreateUsersWeeklyOffs < ActiveRecord::Migration
  def change
    create_table :users_weekly_offs do |t|
      t.integer :user_id
      t.integer :weekly_off_id
    end
  end
end
