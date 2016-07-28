class AddColmnToRequests < ActiveRecord::Migration
  def change
  	add_column :requests, :approver_approve_date, :string
  	add_column :requests, :cmo_approve_date, :string
  end
end
