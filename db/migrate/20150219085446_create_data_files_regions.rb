class CreateDataFilesRegions < ActiveRecord::Migration
  def change
    create_table :data_files_regions do |t|
      t.integer :data_file_id
      t.integer :region_id
    end
    add_index :data_files_regions, [:data_file_id, :region_id], :unique => true
  end
end
