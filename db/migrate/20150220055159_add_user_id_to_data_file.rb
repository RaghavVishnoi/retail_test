class AddUserIdToDataFile < ActiveRecord::Migration
  def change
    add_column :data_files, :user_id, :integer
    add_index :data_files, :user_id
  end
end
