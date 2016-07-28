class CreateUserDepartment < ActiveRecord::Migration
  def change
    create_table :departments_users, :id => false do |t|
      t.integer :user_id
      t.integer :department_id
    end
  end
end
