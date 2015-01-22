class CreateItem < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :name
      t.integer :city_id
      t.integer :item_region_id
      t.integer :category_id
      t.integer :subcategory_id
      t.text :short_description
      t.text :details
      t.integer :collection_id
      t.integer :size_id
      t.integer :alcohol_percent_id
      t.text :prices
      t.timestamps
    end
  end
end