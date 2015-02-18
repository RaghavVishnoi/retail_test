class CreateField < ActiveRecord::Migration
  def change
    create_table :fields do |t|
      t.integer :entity
      t.string :display_name
      t.timestamps
    end
  end
end
