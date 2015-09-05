class AddStatusInUser < ActiveRecord::Migration
  def change
  	add_column :users, :status, :string, :default => 'Active', :null => false
  end
end
