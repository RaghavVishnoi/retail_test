class ChangeDatatypeOfPhone < ActiveRecord::Migration
  def change
  	    #change_column :users, :phone, :integer
  	    change_column :users, :phone, 'integer USING CAST(phone AS integer)'

  end
end
