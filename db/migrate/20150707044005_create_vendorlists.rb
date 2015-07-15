class CreateVendorlist < ActiveRecord::Migration
  def change
    create_table :vendorlists do |t|
    	t.string :region
    	t.string :state
    	t.string :vendor_name
    	t.string :contact_person
    	t.string :email
    end
  end
end
