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

ActiveRecord::Schema.define(version: 20170302003644) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "customers", force: :cascade do |t|
    t.string   "name",               limit: 255
    t.string   "business_name",      limit: 255
    t.string   "iva_kind",           limit: 1,   null: false
    t.string   "bill_kind",          limit: 1,   null: false
    t.string   "address",            limit: 255
    t.string   "cuit",               limit: 255
    t.string   "phone",              limit: 255
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "default_price_type", limit: 255
    t.index ["business_name"], name: "index_customers_on_business_name", unique: true, using: :btree
    t.index ["cuit"], name: "index_customers_on_cuit", unique: true, using: :btree
  end

  create_table "places", force: :cascade do |t|
    t.string   "description",      limit: 255,                 null: false
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.boolean  "transfer_default",             default: false
    t.index ["description"], name: "index_places_on_description", unique: true, using: :btree
  end

  create_table "product_lines", force: :cascade do |t|
    t.integer  "product_id",                                         null: false
    t.decimal  "quantity",                  precision: 10, scale: 3, null: false
    t.decimal  "price",                     precision: 15, scale: 2, null: false
    t.integer  "sale_id",                                            null: false
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.decimal  "unit_price",                precision: 15, scale: 2, null: false
    t.string   "price_type",    limit: 255
    t.decimal  "iva_cost",                  precision: 15, scale: 2, null: false
    t.decimal  "cost",                      precision: 15, scale: 2, null: false
    t.decimal  "gain",                      precision: 15, scale: 2, null: false
    t.decimal  "retail_price",              precision: 15, scale: 2, null: false
    t.decimal  "special_gain",              precision: 15, scale: 2, null: false
    t.decimal  "special_price",             precision: 15, scale: 2, null: false
    t.decimal  "unit_gain",                 precision: 15, scale: 2, null: false
    t.index ["product_id"], name: "index_product_lines_on_product_id", using: :btree
    t.index ["sale_id"], name: "index_product_lines_on_sale_id", using: :btree
  end

  create_table "products", force: :cascade do |t|
    t.string   "code",                                                                null: false
    t.string   "description",    limit: 255,                                          null: false
    t.string   "retail_unit",    limit: 2
    t.string   "purchase_unit",  limit: 2
    t.decimal  "unity_relation",             precision: 15, scale: 2
    t.decimal  "total_stock",                precision: 15, scale: 2
    t.decimal  "min_stock",                  precision: 15, scale: 2
    t.decimal  "packs",                      precision: 15, scale: 2
    t.decimal  "cost",                       precision: 15, scale: 2
    t.decimal  "iva_cost",                   precision: 15, scale: 2
    t.decimal  "gain",                       precision: 4,  scale: 2
    t.decimal  "retail_price",               precision: 15, scale: 2
    t.decimal  "unit_price",                 precision: 15, scale: 2
    t.decimal  "special_price",              precision: 15, scale: 2
    t.integer  "provider_id"
    t.datetime "created_at",                                                          null: false
    t.datetime "updated_at",                                                          null: false
    t.decimal  "unit_gain",                  precision: 15, scale: 2
    t.decimal  "special_gain",               precision: 15, scale: 2
    t.boolean  "preference",                                          default: false
    t.index ["code"], name: "index_products_on_code", unique: true, using: :btree
    t.index ["description"], name: "index_products_on_description", using: :btree
    t.index ["provider_id"], name: "index_products_on_provider_id", using: :btree
  end

  create_table "providers", force: :cascade do |t|
    t.string   "name",        limit: 255, null: false
    t.string   "contact",     limit: 255
    t.string   "address",     limit: 255
    t.string   "cuit",        limit: 255, null: false
    t.string   "phone",       limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "other_phone", limit: 255
    t.string   "locality",    limit: 255
    t.string   "city",        limit: 255
    t.string   "province",    limit: 255
    t.string   "fax",         limit: 255
    t.integer  "postal_code"
    t.index ["cuit"], name: "index_providers_on_cuit", unique: true, using: :btree
    t.index ["name"], name: "index_providers_on_name", using: :btree
  end

  create_table "sales", force: :cascade do |t|
    t.integer  "customer_id"
    t.integer  "seller_id",                                                       null: false
    t.string   "sale_kind",    limit: 1
    t.decimal  "total_price",            precision: 15, scale: 2,                 null: false
    t.datetime "created_at",                                                      null: false
    t.datetime "updated_at",                                                      null: false
    t.integer  "place_id"
    t.boolean  "revoked",                                         default: false
    t.string   "payment_type",                                    default: "C"
    t.index ["customer_id"], name: "index_sales_on_customer_id", using: :btree
    t.index ["seller_id"], name: "index_sales_on_seller_id", using: :btree
  end

  create_table "sellers", force: :cascade do |t|
    t.integer  "code",                   null: false
    t.string   "name",       limit: 255, null: false
    t.string   "address",    limit: 255
    t.string   "phone",      limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.index ["code"], name: "index_sellers_on_code", unique: true, using: :btree
    t.index ["name"], name: "index_sellers_on_name", using: :btree
  end

  create_table "transfer_lines", force: :cascade do |t|
    t.integer  "product_id",                                   null: false
    t.decimal  "quantity",            precision: 10, scale: 3, null: false
    t.integer  "transfer_product_id",                          null: false
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.decimal  "price",               precision: 15, scale: 2
    t.index ["product_id"], name: "index_transfer_lines_on_product_id", using: :btree
    t.index ["transfer_product_id"], name: "index_transfer_lines_on_transfer_product_id", using: :btree
  end

  create_table "transfer_products", force: :cascade do |t|
    t.integer  "place_id"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.decimal  "total_price", precision: 15, scale: 2
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",                   limit: 255,              null: false
    t.string   "lastname",               limit: 255
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.integer  "roles_mask",                         default: 0,  null: false
    t.integer  "lock_version",                       default: 0,  null: false
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.integer  "place_id"
    t.string   "username",               limit: 255
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["lastname"], name: "index_users_on_lastname", using: :btree
    t.index ["name"], name: "index_users_on_name", using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    t.index ["username"], name: "index_users_on_username", unique: true, using: :btree
  end

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",  limit: 255, null: false
    t.integer  "item_id",                null: false
    t.string   "event",      limit: 255, null: false
    t.integer  "whodunnit"
    t.text     "object"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree
    t.index ["whodunnit"], name: "index_versions_on_whodunnit", using: :btree
  end

end
