class AddImageableColumnToImages < ActiveRecord::Migration
  def change
    add_column :images, :imageable_id, :integer
    add_column :images, :imageable_type, :string
    remove_column :images, :item_id
    add_index :images, [:imageable_id, :imageable_type]
  end
end
