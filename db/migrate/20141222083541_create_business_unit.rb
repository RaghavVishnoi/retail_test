class CreateBusinessUnit < ActiveRecord::Migration
  def change
    create_table :business_units do |t|
      t.string :name
    end
  end
end
