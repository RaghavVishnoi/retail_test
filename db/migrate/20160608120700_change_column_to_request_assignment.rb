class ChangeColumnToRequestAssignment < ActiveRecord::Migration
  def change
  	change_column :request_assignments,:priority,:string,default: 'normal'
  end
end
