class Pictures < ActiveRecord::Migration
  def change
  	create_table :pictures do |t|
      t.integer :object_id
      t.string :object_type
      t.string :picture
      t.timestamps null: false
    end
    add_reference :pictures, :sales_order, index: true, foreign_key: true,column: :object_id
    add_index :pictures, [:object_id, :object_type]
  end

  
end
