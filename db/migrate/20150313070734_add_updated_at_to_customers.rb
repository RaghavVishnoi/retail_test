class AddUpdatedAtToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :updated_at, :datetime
    add_column :customers, :created_at, :datetime
    add_index :customers, :updated_at
  end
end
