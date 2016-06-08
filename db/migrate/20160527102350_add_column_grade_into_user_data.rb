class AddColumnGradeIntoUserData < ActiveRecord::Migration
  def change
  	add_column :user_data,:grade,:string
  end
end
