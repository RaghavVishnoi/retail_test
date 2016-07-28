class AddIndexOnImagesAndInventories < ActiveRecord::Migration
  def change
    add_index :images, :item_id
    add_index :inventories, :item_id
  end
end
