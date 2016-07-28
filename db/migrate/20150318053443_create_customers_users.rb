class CreateCustomersUsers < ActiveRecord::Migration
  def change
    create_table :customers_users do |t|
      t.integer :customer_id
      t.integer :user_id
      t.timestamps
    end
    add_index :customers_users, :customer_id
    add_index :customers_users, :user_id
  end
end
