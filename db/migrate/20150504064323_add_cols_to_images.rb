class AddColsToImages < ActiveRecord::Migration
  def change
    add_column :images, :address, :string
  end
end
