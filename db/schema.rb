# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160608120700) do

  create_table "GioneeRetailer", id: false, force: true do |t|
    t.text "Code",     null: false
    t.text "Address",  null: false
    t.text "Address2", null: false
  end

  create_table "addresses", force: true do |t|
    t.string "address"
    t.string "city"
    t.string "state"
    t.string "country"
    t.string "addressable_type"
  end

  create_table "alcohol_percents", force: true do |t|
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "answer_options", force: true do |t|
    t.integer "answer_id"
    t.integer "question_option_id"
  end

  add_index "answer_options", ["answer_id"], name: "index_answer_options_on_answer_id", using: :btree

  create_table "answers", force: true do |t|
    t.integer  "question_id"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "answers", ["question_id"], name: "index_answers_on_question_id", using: :btree

  create_table "apps", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "apps_module_groups", force: true do |t|
    t.integer  "app_id"
    t.integer  "module_group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "associated_roles", force: true do |t|
    t.integer  "object_id"
    t.string   "object_type"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "associated_roles", ["object_id", "object_type"], name: "index_associated_roles_on_object_id_and_object_type", using: :btree

  create_table "attendances", force: true do |t|
    t.integer  "user_id"
    t.datetime "punch_in_time"
    t.string   "punch_in_image"
    t.datetime "request_in_time"
    t.string   "punch_in_lat"
    t.string   "punch_in_long"
    t.string   "punch_in_ip"
    t.datetime "punch_out_time"
    t.string   "punch_out_image"
    t.string   "punch_out_lat"
    t.string   "punch_out_long"
    t.string   "punch_out_ip"
    t.datetime "request_out_time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "attendances", ["punch_in_time"], name: "index_attendances_on_punch_in_time", using: :btree
  add_index "attendances", ["punch_out_time"], name: "index_attendances_on_punch_out_time", using: :btree
  add_index "attendances", ["user_id", "punch_in_time"], name: "index_attendances_on_user_id_and_punch_in_time", using: :btree
  add_index "attendances", ["user_id"], name: "index_attendances_on_user_id", using: :btree

  create_table "beatroutes", force: true do |t|
    t.string   "distributor_name"
    t.string   "tsm_name"
    t.string   "rsp_name"
    t.string   "rsp_id"
    t.string   "employee_code"
    t.string   "shop_code"
    t.string   "retailer_code"
    t.string   "retailer_name"
    t.string   "city"
    t.string   "last_month_avg_sales_volume"
    t.string   "last_month_avg_sales_value"
    t.string   "mtd_avg_sales_volume"
    t.string   "mtd_avg_sales_value"
    t.string   "avg_last_month_attendance"
    t.string   "last_reported_stock"
    t.string   "models_in_stock"
    t.string   "distance_btwn_beatroute_and_app_location"
    t.string   "sis_type"
    t.string   "sis_installed_on"
    t.string   "gsb_type"
    t.string   "gsb_installed_on"
    t.string   "clipon"
    t.string   "countertop"
    t.string   "flange"
    t.string   "standee"
    t.string   "inshop_branding"
    t.string   "sis"
    t.string   "gsb"
    t.datetime "created_at",                               default: '2015-09-30 12:46:37'
    t.datetime "updated_at",                               default: '2015-09-30 12:46:37'
  end

  create_table "business_units", force: true do |t|
    t.string "name"
  end

  create_table "business_units_users", force: true do |t|
    t.integer "business_unit_id"
    t.integer "user_id"
  end

  create_table "categories", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cities", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cmos", force: true do |t|
    t.string   "name"
    t.string   "location"
    t.string   "designation"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status",      default: "Active"
    t.string   "phone"
  end

  create_table "collections", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contacts", force: true do |t|
    t.integer  "customer_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "designation"
    t.string   "phone"
    t.string   "avatar"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "contacts", ["customer_id"], name: "index_contacts_on_customer_id", using: :btree

  create_table "customers", force: true do |t|
    t.string   "name"
    t.string   "customer_type"
    t.string   "website"
    t.string   "account_owner"
    t.integer  "parent_customer_id"
    t.string   "phone"
    t.string   "industry"
    t.string   "customer_group"
    t.string   "description"
    t.string   "phone1"
    t.string   "phone2"
    t.string   "email1"
    t.string   "email2"
    t.text     "licence_details"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "customers_users", force: true do |t|
    t.integer  "customer_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "customers_users", ["customer_id"], name: "index_customers_users_on_customer_id", using: :btree
  add_index "customers_users", ["user_id"], name: "index_customers_users_on_user_id", using: :btree

  create_table "data_files", force: true do |t|
    t.string   "type"
    t.string   "data_file"
    t.boolean  "sharable"
    t.string   "description"
    t.string   "name"
    t.integer  "parent_id"
    t.integer  "lft",         null: false
    t.integer  "rgt",         null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "item_id"
    t.integer  "user_id"
  end

  add_index "data_files", ["item_id"], name: "index_data_files_on_item_id", using: :btree
  add_index "data_files", ["user_id"], name: "index_data_files_on_user_id", using: :btree

  create_table "data_files_regions", force: true do |t|
    t.integer "data_file_id"
    t.integer "region_id"
  end

  add_index "data_files_regions", ["data_file_id", "region_id"], name: "index_data_files_regions_on_data_file_id_and_region_id", unique: true, using: :btree

  create_table "data_files_users", force: true do |t|
    t.integer "data_file_id"
    t.integer "user_id"
  end

  add_index "data_files_users", ["data_file_id", "user_id"], name: "index_data_files_users_on_data_file_id_and_user_id", unique: true, using: :btree

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "departments", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "departments_users", id: false, force: true do |t|
    t.integer "user_id"
    t.integer "department_id"
  end

  create_table "devices", force: true do |t|
    t.string   "device_holder_email"
    t.string   "device_holder_state"
    t.string   "device_holder_city"
    t.string   "device_name"
    t.string   "device_imei"
    t.string   "device_registration_id"
    t.string   "app_id"
    t.datetime "device_registration_date"
    t.string   "status"
  end

  create_table "documents", force: true do |t|
    t.string   "document_title"
    t.datetime "uploaded_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "file_size"
    t.string   "document_name"
  end

  create_table "field_values", force: true do |t|
    t.integer  "field_id"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fields", force: true do |t|
    t.integer  "entity"
    t.string   "display_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "field_type"
    t.text     "configuration"
    t.integer  "value_type"
    t.boolean  "mandatory",     default: false
  end

  create_table "holidays", force: true do |t|
    t.string   "description"
    t.string   "timezone"
    t.date     "date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "images", force: true do |t|
    t.string   "image"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "imageable_id"
    t.string   "imageable_type"
    t.string   "lat"
    t.string   "long"
    t.string   "address"
  end

  add_index "images", ["imageable_id", "imageable_type"], name: "index_images_on_imageable_id_and_imageable_type", using: :btree

  create_table "inventories", force: true do |t|
    t.integer  "item_id"
    t.integer  "quantity"
    t.integer  "warehouse_id"
    t.integer  "low_stock_trigger_quantity"
    t.datetime "restock_time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "inventories", ["item_id"], name: "index_inventories_on_item_id", using: :btree

  create_table "item_regions", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "items", force: true do |t|
    t.string   "name"
    t.integer  "city_id"
    t.integer  "item_region_id"
    t.integer  "category_id"
    t.integer  "subcategory_id"
    t.text     "short_description"
    t.text     "details"
    t.integer  "collection_id"
    t.integer  "size_id"
    t.integer  "alcohol_percent_id"
    t.text     "prices"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "quantity"
    t.string   "unit_of_measurement"
  end

  create_table "job_titles", force: true do |t|
    t.string "title"
  end

  create_table "job_titles_users", force: true do |t|
    t.integer "user_id"
    t.integer "job_title_id"
  end

  create_table "levels", force: true do |t|
    t.string   "level_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "line_items", force: true do |t|
    t.integer  "order_id"
    t.integer  "item_id"
    t.integer  "quantity"
    t.decimal  "price",      precision: 10, scale: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "module_groups", force: true do |t|
    t.integer "name"
  end

  create_table "notifications", force: true do |t|
    t.string  "state"
    t.string  "city"
    t.string  "message"
    t.date    "send_date"
    t.string  "status"
    t.string  "user_type"
    t.integer "app_id"
  end

  create_table "orders", force: true do |t|
    t.integer  "customer_id"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "organizations", force: true do |t|
    t.string   "name"
    t.string   "logo"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "permissions", force: true do |t|
    t.integer  "role_id"
    t.string   "action"
    t.string   "subject_class"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "permissions", ["role_id"], name: "index_permissions_on_role_id", using: :btree

  create_table "question_options", force: true do |t|
    t.integer  "question_id"
    t.string   "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "question_options", ["question_id"], name: "index_question_options_on_question_id", using: :btree

  create_table "questions", force: true do |t|
    t.integer  "survey_id"
    t.text     "content"
    t.integer  "question_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "questions", ["survey_id"], name: "index_questions_on_survey_id", using: :btree

  create_table "regions", force: true do |t|
    t.string "name"
  end

  create_table "regions_users", force: true do |t|
    t.integer "region_id"
    t.integer "user_id"
  end

  create_table "repositories", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "documents_id"
    t.integer  "levels_id"
    t.integer  "tags_id"
    t.integer  "users_id"
  end

  add_index "repositories", ["documents_id"], name: "index_repositories_on_documents_id", using: :btree
  add_index "repositories", ["levels_id"], name: "index_repositories_on_levels_id", using: :btree
  add_index "repositories", ["tags_id"], name: "index_repositories_on_tags_id", using: :btree
  add_index "repositories", ["users_id"], name: "index_repositories_on_users_id", using: :btree

  create_table "request_activities", force: true do |t|
    t.integer  "request_id"
    t.string   "request_status"
    t.integer  "user_id"
    t.string   "user_type"
    t.string   "comment"
    t.string   "activity_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "request_activities", ["request_id"], name: "index_request_activities_on_request_id", using: :btree
  add_index "request_activities", ["user_id"], name: "index_request_activities_on_user_id", using: :btree

  create_table "request_assignment_activities", force: true do |t|
    t.string   "user_type"
    t.string   "status"
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "request_assignment_id"
    t.integer  "user_id"
  end

  add_index "request_assignment_activities", ["request_assignment_id"], name: "index_request_assignment_activities_on_request_assignment_id", using: :btree
  add_index "request_assignment_activities", ["user_id"], name: "index_request_assignment_activities_on_user_id", using: :btree

  create_table "request_assignments", force: true do |t|
    t.integer  "user_id"
    t.integer  "request_id"
    t.datetime "assign_date"
    t.string   "current_stage"
    t.string   "status"
    t.string   "user_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "upload_bill",   default: 0
    t.string   "po_number"
    t.boolean  "is_rrm",        default: false
    t.boolean  "is_valc",       default: false
    t.string   "priority",      default: "normal"
  end

  create_table "request_documents", force: true do |t|
    t.string   "request_document"
    t.string   "request_document_id"
    t.string   "request_document_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "requests", force: true do |t|
    t.string   "retailer_code"
    t.string   "rsp_name"
    t.string   "rsp_mobile_number"
    t.string   "rsp_app_user_id"
    t.string   "state"
    t.string   "city"
    t.string   "shop_name"
    t.string   "shop_address"
    t.string   "shop_owner_name"
    t.string   "shop_owner_phone"
    t.boolean  "is_main_signage"
    t.boolean  "is_sis_installed"
    t.decimal  "avg_store_monthly_sales",             precision: 10, scale: 2
    t.decimal  "avg_gionee_monthly_sales",            precision: 10, scale: 2
    t.integer  "request_type"
    t.text     "remarks"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status"
    t.integer  "approved_by_user_id"
    t.integer  "declined_by_user_id"
    t.boolean  "is_gionee_gsb_present"
    t.boolean  "is_rsp"
    t.string   "rsp_not_present_reason"
    t.string   "type_of_sis_required"
    t.string   "space_available"
    t.string   "type_of_gsb_requested"
    t.decimal  "width",                               precision: 10, scale: 4
    t.decimal  "height",                              precision: 10, scale: 4
    t.boolean  "is_gsb_installed_outside"
    t.integer  "cmo_id"
    t.text     "comment_by_approver"
    t.text     "comment_by_cmo"
    t.string   "maintenance_requestor"
    t.string   "maintenance_requestor_mobile_number"
    t.string   "type_of_issue"
    t.string   "type_of_problem"
    t.string   "shop_visit_date"
    t.string   "shop_visit_done_by"
    t.string   "visitor_contact_number"
    t.string   "store_selling_gionee"
    t.string   "is_clipon_present"
    t.string   "is_countertop_present"
    t.string   "is_standee_present"
    t.string   "no_of_peace_in_stock"
    t.string   "is_leaflets_available"
    t.string   "is_wall_poster_in_shop"
    t.string   "is_dangler_in_shop"
    t.string   "rsp_assigned_in_store"
    t.string   "rsp_present_in_shop"
    t.string   "rsp_in_gionee_tshirt"
    t.string   "rsp_well_groomed"
    t.string   "rsp_selling_skills"
    t.string   "gsb_type_installed"
    t.string   "location_of_gsb"
    t.string   "gsb_cleanliness"
    t.string   "installation_quality"
    t.string   "is_gsb_light_woring"
    t.string   "is_gsb_light_throw_is_good"
    t.text     "gsb_structured_damage"
    t.text     "gsb_other_problem"
    t.string   "gsb_retailer_feedback"
    t.string   "is_sis_present"
    t.string   "is_sis_placed_properly"
    t.string   "is_sis_condition_good"
    t.string   "is_sis_cleaned_daily"
    t.string   "is_sis_damaged"
    t.string   "sis_structured_flaws"
    t.string   "sis_security_alarm_working"
    t.string   "sis_security_device_charging"
    t.string   "sis_demo_phones_installed"
    t.string   "spec_card_demo_phone_match"
    t.string   "backwall_light_working_properly"
    t.string   "is_counter_lights_working"
    t.string   "is_clip_on_lights"
    t.string   "dealer_switch_on_sis_lights"
    t.string   "updated_gionee_creative"
    t.text     "sis_any_problem"
    t.text     "sis_retailer_feedback"
    t.string   "is_good_visibility_in_store"
    t.string   "lit_in_store"
    t.string   "has_a_relevant_visual"
    t.string   "overall_rating"
    t.string   "is_clipon_not_working_properly"
    t.text     "overall_comments"
    t.string   "approver_approve_date"
    t.string   "cmo_approve_date"
    t.integer  "user_id"
    t.string   "other_name"
    t.string   "other_phone"
    t.string   "other_address"
    t.string   "lfr_name"
    t.string   "lfr_phone"
    t.string   "lfr_app_user_id"
    t.integer  "is_other"
    t.integer  "is_lfr"
    t.boolean  "is_audit_done",                                                default: true
    t.string   "store_open"
    t.string   "store_renovation"
    t.string   "store_shifted"
    t.string   "not_allowed_in_store"
    t.integer  "state_id"
    t.integer  "is_fixed",                                                     default: 0
  end

  add_index "requests", ["cmo_id"], name: "index_requests_on_cmo_id", using: :btree
  add_index "requests", ["request_type"], name: "index_requests_on_request_type", using: :btree
  add_index "requests", ["retailer_code"], name: "index6", using: :btree
  add_index "requests", ["status"], name: "index_requests_on_status", using: :btree
  add_index "requests", ["user_id"], name: "index_requests_on_user_id", using: :btree

  create_table "retailers", force: true do |t|
    t.string   "retailer_name"
    t.string   "retailer_code"
    t.string   "sales_channel"
    t.string   "contact_person"
    t.string   "state"
    t.string   "city"
    t.string   "pincode",              limit: 50
    t.string   "tin_number",           limit: 50
    t.string   "mobile_number",        limit: 50
    t.string   "status",                           default: "Active"
    t.string   "is_isp_on_counter"
    t.string   "counter_size"
    t.string   "record_creation_date"
    t.string   "nd",                   limit: 100
    t.string   "lfr_chain",            limit: 100
    t.text     "address"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "retailers", ["retailer_code"], name: "index2", using: :btree

  create_table "retailers_backup", force: true do |t|
    t.string   "retailer_name"
    t.string   "retailer_code"
    t.string   "sales_channel"
    t.string   "contact_person"
    t.string   "state"
    t.string   "city"
    t.string   "pincode",              limit: 50
    t.string   "tin_number",           limit: 50
    t.string   "mobile_number",        limit: 50
    t.string   "status"
    t.string   "is_isp_on_counter"
    t.string   "counter_size"
    t.string   "record_creation_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rpush_apps", force: true do |t|
    t.string   "name",                                null: false
    t.string   "environment"
    t.text     "certificate"
    t.string   "password"
    t.integer  "connections",             default: 1, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type",                                null: false
    t.string   "auth_key"
    t.string   "client_id"
    t.string   "client_secret"
    t.string   "access_token"
    t.datetime "access_token_expiration"
  end

  create_table "rpush_feedback", force: true do |t|
    t.string   "device_token", limit: 64, null: false
    t.datetime "failed_at",               null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "app_id"
  end

  add_index "rpush_feedback", ["device_token"], name: "index_rpush_feedback_on_device_token", using: :btree

  create_table "rpush_notifications", force: true do |t|
    t.integer  "badge"
    t.string   "device_token",      limit: 64
    t.string   "sound",                              default: "default"
    t.string   "alert"
    t.text     "data"
    t.integer  "expiry",                             default: 86400
    t.boolean  "delivered",                          default: false,     null: false
    t.datetime "delivered_at"
    t.boolean  "failed",                             default: false,     null: false
    t.datetime "failed_at"
    t.integer  "error_code"
    t.text     "error_description"
    t.datetime "deliver_after"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "alert_is_json",                      default: false
    t.string   "type",                                                   null: false
    t.string   "collapse_key"
    t.boolean  "delay_while_idle",                   default: false,     null: false
    t.text     "registration_ids",  limit: 16777215
    t.integer  "app_id",                                                 null: false
    t.integer  "retries",                            default: 0
    t.string   "uri"
    t.datetime "fail_after"
    t.boolean  "processing",                         default: false,     null: false
    t.integer  "priority"
    t.text     "url_args"
    t.string   "category"
  end

  add_index "rpush_notifications", ["app_id", "delivered", "failed", "deliver_after"], name: "index_rapns_notifications_multi", using: :btree
  add_index "rpush_notifications", ["delivered", "failed"], name: "index_rpush_notifications_multi", using: :btree

  create_table "screens", force: true do |t|
    t.text     "layout"
    t.integer  "module_group_id"
    t.boolean  "is_start_screen", default: false
    t.boolean  "is_menu",         default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "shop_assignments", force: true do |t|
    t.datetime "assign_date"
    t.string   "status",          default: "pending"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "retailer_id"
    t.integer  "request_id"
    t.integer  "assignment_type", default: 1
  end

  add_index "shop_assignments", ["request_id"], name: "index_shop_assignments_on_request_id", using: :btree
  add_index "shop_assignments", ["retailer_id"], name: "index_shop_assignments_on_retailers_id", using: :btree
  add_index "shop_assignments", ["user_id"], name: "index_shop_assignments_on_users_id", using: :btree

  create_table "sizes", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "states", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "surveys", force: true do |t|
    t.string   "heading"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tags", force: true do |t|
    t.string   "tag_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "upload_files", force: true do |t|
    t.string   "file_name"
    t.datetime "uploaded_on"
    t.datetime "inserted_on"
    t.string   "type"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_data", force: true do |t|
    t.string   "name"
    t.string   "location"
    t.string   "designation"
    t.string   "email"
    t.string   "status"
    t.string   "phone"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "grade",       limit: 1
  end

  add_index "user_data", ["user_id"], name: "index_user_data_on_user_id", using: :btree

  create_table "user_parents", force: true do |t|
    t.integer  "parent_id"
    t.integer  "user_id"
    t.string   "role"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "users_id"
  end

  add_index "user_parents", ["user_id"], name: "index_user_parents_on_user_id", using: :btree
  add_index "user_parents", ["user_id"], name: "parent_id", using: :btree

  create_table "user_states", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "state_id"
    t.string   "user_type"
  end

  add_index "user_states", ["state_id"], name: "index_user_states_on_state_id", using: :btree
  add_index "user_states", ["user_id"], name: "index_user_states_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email"
    t.string   "auth_token"
    t.string   "name"
    t.string   "password_digest"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.integer  "shift_start_time_in_seconds"
    t.integer  "shift_end_time_in_seconds"
    t.string   "timezone"
    t.string   "status",                      default: "Active", null: false
    t.string   "state"
    t.datetime "created_at"
    t.string   "phone"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "users_reportings", force: true do |t|
    t.integer "reporting_user_id"
    t.integer "report_to_user_id"
  end

  add_index "users_reportings", ["report_to_user_id"], name: "index_users_reportings_on_report_to_user_id", using: :btree
  add_index "users_reportings", ["reporting_user_id", "report_to_user_id"], name: "reporting_users_and_report_to_users", using: :btree
  add_index "users_reportings", ["reporting_user_id"], name: "index_users_reportings_on_reporting_user_id", using: :btree

  create_table "users_weekly_offs", force: true do |t|
    t.integer "user_id"
    t.integer "weekly_off_id"
  end

  create_table "vendor_requests", force: true do |t|
    t.string   "installation_of"
    t.string   "installation_report"
    t.datetime "installed_on"
    t.string   "status"
    t.text     "cmo_comment"
    t.datetime "cmo_response_date"
    t.text     "rrm_comment"
    t.datetime "rrm_response_date"
    t.integer  "request_assignment_id"
  end

  add_index "vendor_requests", ["request_assignment_id"], name: "index_vendor_requests_on_request_assignment_id", using: :btree

  create_table "vendor_stages", force: true do |t|
    t.string   "stage_name"
    t.datetime "update_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "request_assignment_id"
  end

  create_table "vendor_tasks", force: true do |t|
    t.string   "retailer_code"
    t.string   "request_id"
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "requestor_type"
    t.integer  "vendor_id"
    t.string   "other_identity"
    t.string   "installation_of"
    t.string   "installation_report"
    t.string   "status"
    t.string   "approver_id"
    t.string   "approver_name"
    t.text     "comment_by_approver"
    t.string   "approver_approve_date"
    t.text     "comment_by_cmo"
    t.string   "cmo_approve_date"
  end

  create_table "vendorlists", force: true do |t|
    t.string "region"
    t.string "state"
    t.string "vendor_name"
    t.string "contact_person"
    t.string "contact_number"
    t.string "email"
    t.string "status",         limit: 45, default: "Active"
  end

  create_table "warehouses", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "weekly_offs", force: true do |t|
    t.integer  "day"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
