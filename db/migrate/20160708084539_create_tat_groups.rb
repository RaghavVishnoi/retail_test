class CreateTatGroups < ActiveRecord::Migration
  def change
    create_table :tat_groups do |t|
    	t.string  :name
    	t.integer :duration
        t.timestamps
    end
  end
end
