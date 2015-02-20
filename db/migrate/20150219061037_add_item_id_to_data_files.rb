class AddItemIdToDataFiles < ActiveRecord::Migration
  def change
    add_column :data_files, :item_id, :integer
    add_index :data_files, :item_id
  end
end
