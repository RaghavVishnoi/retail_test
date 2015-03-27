class AddShiftStartTimeAndShiftEndTimeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :shift_start_time_in_seconds, :integer
    add_column :users, :shift_end_time_in_seconds, :integer
  end
end
