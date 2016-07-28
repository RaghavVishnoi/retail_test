class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
    	t.string :device_holder_email
    	t.string :device_holder_state
    	t.string :device_holder_city
    	t.string :device_name
    	t.string :device_imei
    	t.string :device_registration_id
        t.string :app_id
    end
  end
end
