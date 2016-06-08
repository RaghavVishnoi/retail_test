class AddDefaultToRequestAssignments < ActiveRecord::Migration
  def change
  	change_column :request_assignments,:is_rrm,:boolean,default: false
  	change_column :request_assignments,:is_valc,:boolean,default: false
  end
end
