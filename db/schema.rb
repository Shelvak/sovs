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

ActiveRecord::Schema.define(:version => 20121221031507) do

  create_table "customers", :force => true do |t|
    t.string   "name"
    t.string   "business_name"
    t.string   "iva_kind",      :limit => 1, :null => false
    t.string   "bill_kind",     :limit => 1, :null => false
    t.string   "address"
    t.string   "cuit"
    t.string   "phone"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  add_index "customers", ["business_name"], :name => "index_customers_on_business_name", :unique => true
  add_index "customers", ["cuit"], :name => "index_customers_on_cuit", :unique => true

  create_table "places", :force => true do |t|
    t.string   "description", :null => false
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "places", ["description"], :name => "index_places_on_description", :unique => true

  create_table "providers", :force => true do |t|
    t.string   "name",       :null => false
    t.string   "contact"
    t.string   "address"
    t.string   "cuit",       :null => false
    t.string   "phone"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "providers", ["cuit"], :name => "index_providers_on_cuit", :unique => true
  add_index "providers", ["name"], :name => "index_providers_on_name"

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
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["lastname"], :name => "index_users_on_lastname"
  add_index "users", ["name"], :name => "index_users_on_name"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

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
