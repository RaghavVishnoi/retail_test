class AddColToImage < ActiveRecord::Migration
  def change
    add_column :images, :lat, :string
    add_column :images, :long, :string
  end
end
