class AddSuperBuildUpAreaToShopDimensions < ActiveRecord::Migration
  def change
  	 add_column :shop_dimensions, :super_build_up_area, :string
  end
end
