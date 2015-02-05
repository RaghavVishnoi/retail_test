class CreateScreen < ActiveRecord::Migration
  def change
    create_table :screens do |t|
      t.text :layout
    end
  end
end
