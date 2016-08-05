class CreateVendorlist < ActiveRecord::Migration
  def change
    create_table :vendorlists do |t|
    	t.string :region
    	t.string :state
    	t.string :vendor_name
    	t.string :contact_person
    	t.string :contact_number
    	t.string :email
    	t.string :status, :default => 'Active'
    end
  end
end
