class AddIndexOnAttendance < ActiveRecord::Migration
  def change
    add_index :attendances, [:user_id, :punch_in_time]
  end
end
