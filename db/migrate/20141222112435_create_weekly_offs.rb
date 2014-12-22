class CreateWeeklyOffs < ActiveRecord::Migration
  def change
    create_table :weekly_offs do |t|
      t.integer :day
      t.timestamps
    end
  end
end
