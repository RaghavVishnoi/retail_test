class CreateShopDimensions < ActiveRecord::Migration
  def change
    create_table :shop_dimensions do |t|
    	t.string :built_up_area
    	t.string :carpet_area
    	t.string :clear_height
    	t.string :seepage
    	t.string :mezzanine_floor
    	t.string :hindrance
    	t.string :power_backup
    	t.string :current_flooring
    	t.string :current_ceilling
    	t.string :current_wall_status
    	t.string :fire_safety
    	t.string :gsb_opportunity
    	t.string :special_visible_opportunity
    	t.string :other_issue
    end
        add_reference :shop_dimensions, :sales_order, index: true, foreign_key: true
  end
end

