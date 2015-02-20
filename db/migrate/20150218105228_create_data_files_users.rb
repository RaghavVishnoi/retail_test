class CreateDataFilesUsers < ActiveRecord::Migration
  def change
    create_table :data_files_users do |t|
      t.integer :data_file_id
      t.integer :user_id
    end
    add_index :data_files_users, [:data_file_id, :user_id], :unique => true
  end
end
