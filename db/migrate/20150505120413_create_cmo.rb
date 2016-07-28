class CreateCmo < ActiveRecord::Migration
  def change
    create_table :cmos do |t|
      t.string :name
      t.string :location
      t.string :designation
      t.string :email
      t.timestamps
    end
  end
end
