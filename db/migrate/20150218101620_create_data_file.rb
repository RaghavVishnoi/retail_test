class CreateDataFile < ActiveRecord::Migration
  def change
    create_table :data_files do |t|
      t.string :type
      t.string :data_file
      t.boolean :sharable
      t.string :description
      t.string :name
      t.integer :parent_id, :null => true, :index => true
      t.integer :lft, :null => false, :index => true
      t.integer :rgt, :null => false, :index => true
      t.integer :roles_mask
      t.timestamps  
    end
  end
end
