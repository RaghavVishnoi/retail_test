class CreateUserParents < ActiveRecord::Migration
  def change
    create_table :user_parents do |t|
      t.integer :parent_id
      t.integer :user_id
      t.string  :role	
      t.timestamps
    end
  end
end
