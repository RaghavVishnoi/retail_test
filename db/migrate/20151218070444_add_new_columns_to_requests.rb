class AddNewColumnsToRequests < ActiveRecord::Migration
  def change
  	add_column :requests,:other_name,:string
  	add_column :requests,:other_phone,:string
  	add_column :requests,:other_address,:string
  	add_column :requests,:lfr_name,:string
  	add_column :requests,:lfr_phone,:string
  	add_column :requests,:lfr_app_user_id,:string

  end
end
