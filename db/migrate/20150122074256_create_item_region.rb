class CreateItemRegion < ActiveRecord::Migration
  def change
    create_table :item_regions do |t|
      t.string :name
      t.timestamps
    end
  end
end
