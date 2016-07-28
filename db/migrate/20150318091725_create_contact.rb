class CreateContact < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.integer :customer_id
      t.string :first_name
      t.string :last_name
      t.string :designation
      t.string :phone
      t.string :avatar
      t.timestamps
    end
    add_index :contacts, :customer_id
  end
end
