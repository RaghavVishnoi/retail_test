class AddColumnsIntoShopAudits < ActiveRecord::Migration
  def change
  	add_column :shop_audits, :range_brochure_avilable,:boolean
    add_column :shop_audits, :leaflet_available,:boolean
    add_column :shop_audits, :poster_available,:boolean
    add_column :shop_audits, :wall_branding_available,:boolean
    add_column :shop_audits, :one_way_vision_available,:boolean
    add_column :shop_audits, :danglers_available,:boolean
    add_column :shop_audits, :shelf_strips_available,:boolean
    add_column :shop_audits, :roll_up_standee_available,:boolean
    add_column :shop_audits, :no_of_range_brochure,:string
    add_column :shop_audits, :range_brochure_type,:string
    add_column :shop_audits, :leaflet_type,:string
    add_column :shop_audits, :poster_type,:string
    add_column :shop_audits, :no_of_wall_branding,:string
    add_column :shop_audits, :wall_branding_type,:string
    add_column :shop_audits, :no_of_one_way_vision,:string
    add_column :shop_audits, :one_way_vision_type,:string
    add_column :shop_audits, :no_of_danglers,:string
    add_column :shop_audits, :danglers_type,:string
    add_column :shop_audits, :no_of_shelf_strips,:string
    add_column :shop_audits, :shelf_strips_type,:string
    add_column :shop_audits, :no_of_roll_up_standee,:string
    add_column :shop_audits, :roll_up_standee_type,:string
    add_column :shop_audits, :escalate_to_tl,:boolean
    add_column :shop_audits, :cleaned_and_checked_clipon,:boolean
  end
end
