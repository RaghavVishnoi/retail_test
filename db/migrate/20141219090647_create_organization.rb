class CreateOrganization < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.string :name
      t.string :logo
      t.timestamps
    end
  end
end
