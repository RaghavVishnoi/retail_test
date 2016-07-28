class AddRegistrationDateToDevices < ActiveRecord::Migration
  def change
  	add_column :devices, :device_registration_date, :datetime
  end
end
