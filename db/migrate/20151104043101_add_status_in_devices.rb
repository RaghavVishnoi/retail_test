class AddStatusInDevices < ActiveRecord::Migration
  def change
  	add_column :devices, :status, :string
  end
end
