class CreateUserData < ActiveRecord::Migration
  def change
    create_table :user_data do |t|
    	t.string  :name
    	t.string  :location
    	t.string  :designation
    	t.string  :email
    	t.string  :status
    	t.string  :phone
    	t.timestamps
    end
      add_reference :user_data, :user, index: true, foreign_key: true
  end
end




