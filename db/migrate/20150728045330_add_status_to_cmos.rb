class AddStatusToCmos < ActiveRecord::Migration
  def change
  	add_column :cmos, :status, :string, default: 'Active'
  end
end
