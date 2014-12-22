class CreateAddress < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :address
      t.string :city
      t.string :state
      t.string :country
    end
  end
end
