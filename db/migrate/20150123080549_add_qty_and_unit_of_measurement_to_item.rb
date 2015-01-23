class AddQtyAndUnitOfMeasurementToItem < ActiveRecord::Migration
  def change
    add_column :items, :quantity, :integer
    add_column :items, :unit_of_measurement, :string
  end
end
