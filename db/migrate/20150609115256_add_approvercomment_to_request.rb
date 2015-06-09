class AddApprovercommentToRequest < ActiveRecord::Migration
  def change

  	add_column :requests, :comment_by_approver, :text

  end
end
