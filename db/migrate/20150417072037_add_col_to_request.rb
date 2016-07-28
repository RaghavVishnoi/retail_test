class AddColToRequest < ActiveRecord::Migration
  def change
    add_column :requests, :width, :decimal, :precision => 10, :scale => 4
    add_column :requests, :height, :decimal, :precision => 10, :scale => 4
  end
end
