class CreateAttendance < ActiveRecord::Migration
  def change
    create_table :attendances do |t|
      t.integer :user_id
      t.datetime :punch_in_time
      t.string :punch_in_image
      t.datetime :request_in_time
      t.string :punch_in_lat
      t.string :punch_in_long
      t.string :punch_in_ip
      t.datetime :punch_out_time
      t.string :punch_out_image
      t.string :punch_out_lat
      t.string :punch_out_long
      t.string :punch_out_ip
      t.datetime :request_out_time
      t.timestamps
    end
    add_index :attendances, :user_id
    add_index :attendances, :punch_in_time
    add_index :attendances, :punch_out_time
  end
end
