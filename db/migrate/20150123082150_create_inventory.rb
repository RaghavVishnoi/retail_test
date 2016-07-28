class CreateInventory < ActiveRecord::Migration
  def change
    create_table :inventories do |t|
      t.integer :item_id
      t.integer :quantity
      t.integer :warehouse_id
      t.integer :low_stock_trigger_quantity
      t.datetime :restock_time
      t.timestamps
    end
  end
end
