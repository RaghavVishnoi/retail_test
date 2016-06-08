class CreateVendorRequests < ActiveRecord::Migration
  def change
    create_table :vendor_requests do |t|
    	t.string :installation_of
    	t.string :installation_report
    	t.datetime :installed_on
    	t.string :status
    	t.text :cmo_comment
    	t.datetime :cmo_response_date
    	t.text :rrm_comment
    	t.datetime :rrm_response_date
    end
    add_reference :vendor_requests,:request_assignment,index: true
  end
end
