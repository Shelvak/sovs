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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20131014223111) do

  create_table "customers", :force => true do |t|
    t.string   "name"
    t.string   "business_name"
    t.string   "iva_kind",           :limit => 1, :null => false
    t.string   "bill_kind",          :limit => 1, :null => false
    t.string   "address"
    t.string   "cuit"
    t.string   "phone"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.string   "default_price_type"
  end

  add_index "customers", ["business_name"], :name => "index_customers_on_business_name", :unique => true
  add_index "customers", ["cuit"], :name => "index_customers_on_cuit", :unique => true

  create_table "places", :force => true do |t|
    t.string   "description",                         :null => false
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.boolean  "transfer_default", :default => false
  end

  add_index "places", ["description"], :name => "index_places_on_description", :unique => true

  create_table "product_lines", :force => true do |t|
    t.integer  "product_id",                                :null => false
    t.decimal  "quantity",                                  :null => false
    t.decimal  "price",                                     :null => false
    t.integer  "sale_id",                                   :null => false
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.decimal  "unit_price", :precision => 15, :scale => 2, :null => false
    t.string   "price_type"
  end

  add_index "product_lines", ["product_id"], :name => "index_product_lines_on_product_id"
  add_index "product_lines", ["sale_id"], :name => "index_product_lines_on_sale_id"

  create_table "products", :force => true do |t|
    t.integer  "code",                                                                          :null => false
    t.string   "description",                                                                   :null => false
    t.string   "retail_unit",    :limit => 2
    t.string   "purchase_unit",  :limit => 2
    t.decimal  "unity_relation",              :precision => 15, :scale => 2
    t.decimal  "total_stock",                 :precision => 15, :scale => 2
    t.decimal  "min_stock",                   :precision => 15, :scale => 2
    t.decimal  "packs",                       :precision => 15, :scale => 2
    t.decimal  "cost",                        :precision => 15, :scale => 2
    t.decimal  "iva_cost",                    :precision => 15, :scale => 2
    t.decimal  "gain",                        :precision => 4,  :scale => 2
    t.decimal  "retail_price",                :precision => 15, :scale => 2
    t.decimal  "unit_price",                  :precision => 15, :scale => 2
    t.decimal  "special_price",               :precision => 15, :scale => 2
    t.integer  "provider_id"
    t.datetime "created_at",                                                                    :null => false
    t.datetime "updated_at",                                                                    :null => false
    t.decimal  "unit_gain",                   :precision => 15, :scale => 2
    t.decimal  "special_gain",                :precision => 15, :scale => 2
    t.boolean  "preference",                                                 :default => false
  end

  add_index "products", ["code"], :name => "index_products_on_code", :unique => true
  add_index "products", ["description"], :name => "index_products_on_description"
  add_index "products", ["provider_id"], :name => "index_products_on_provider_id"

  create_table "providers", :force => true do |t|
    t.string   "name",        :null => false
    t.string   "contact"
    t.string   "address"
    t.string   "cuit",        :null => false
    t.string   "phone"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "other_phone"
    t.string   "locality"
    t.string   "city"
    t.string   "province"
    t.string   "fax"
    t.integer  "postal_code"
  end

  add_index "providers", ["cuit"], :name => "index_providers_on_cuit", :unique => true
  add_index "providers", ["name"], :name => "index_providers_on_name"

  create_table "sales", :force => true do |t|
    t.integer  "customer_id"
    t.integer  "seller_id",                                   :null => false
    t.string   "sale_kind",   :limit => 1
    t.decimal  "total_price",                                 :null => false
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
    t.integer  "place_id"
    t.boolean  "revoked",                  :default => false
  end

  add_index "sales", ["customer_id"], :name => "index_sales_on_customer_id"
  add_index "sales", ["seller_id"], :name => "index_sales_on_seller_id"

  create_table "sellers", :force => true do |t|
    t.integer  "code",       :null => false
    t.string   "name",       :null => false
    t.string   "address"
    t.string   "phone"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sellers", ["code"], :name => "index_sellers_on_code", :unique => true
  add_index "sellers", ["name"], :name => "index_sellers_on_name"

  create_table "transfer_lines", :force => true do |t|
    t.integer  "product_id",                                         :null => false
    t.decimal  "quantity",            :precision => 10, :scale => 3, :null => false
    t.integer  "transfer_product_id",                                :null => false
    t.datetime "created_at",                                         :null => false
    t.datetime "updated_at",                                         :null => false
    t.decimal  "price",               :precision => 15, :scale => 2
  end

  add_index "transfer_lines", ["product_id"], :name => "index_transfer_lines_on_product_id"
  add_index "transfer_lines", ["transfer_product_id"], :name => "index_transfer_lines_on_transfer_product_id"

  create_table "transfer_products", :force => true do |t|
    t.integer  "place_id"
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.decimal  "total_price", :precision => 15, :scale => 2
  end

  create_table "users", :force => true do |t|
    t.string   "name",                                   :null => false
    t.string   "lastname"
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "roles_mask",             :default => 0,  :null => false
    t.integer  "lock_version",           :default => 0,  :null => false
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.integer  "place_id"
    t.string   "username"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["lastname"], :name => "index_users_on_lastname"
  add_index "users", ["name"], :name => "index_users_on_name"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["username"], :name => "index_users_on_username", :unique => true

  create_table "versions", :force => true do |t|
    t.string   "item_type",  :null => false
    t.integer  "item_id",    :null => false
    t.string   "event",      :null => false
    t.integer  "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], :name => "index_versions_on_item_type_and_item_id"
  add_index "versions", ["whodunnit"], :name => "index_versions_on_whodunnit"

end
