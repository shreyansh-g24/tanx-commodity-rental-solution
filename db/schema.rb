# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2024_09_26_050530) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bids", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "listing_id", null: false
    t.float "price_per_month", default: 0.0, null: false
    t.integer "number_of_months", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["listing_id"], name: "index_bids_on_listing_id"
    t.index ["user_id", "listing_id"], name: "index_bids_on_user_id_and_listing_id", unique: true
    t.index ["user_id"], name: "index_bids_on_user_id"
  end

  create_table "commodities", force: :cascade do |t|
    t.string "name", null: false
    t.string "description"
    t.string "category", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_commodities_on_user_id"
  end

  create_table "listings", force: :cascade do |t|
    t.bigint "commodity_id", null: false
    t.string "status", null: false
    t.string "selection_strategy", null: false
    t.float "quote_price_per_month", default: 0.0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "selected_bid_id"
    t.index ["commodity_id"], name: "index_listings_on_commodity_id"
    t.index ["selected_bid_id"], name: "index_listings_on_selected_bid_id", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "email", null: false
    t.string "password_hash", null: false
    t.string "user_type", null: false
    t.string "jwt_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "bids", "listings"
  add_foreign_key "bids", "users"
  add_foreign_key "commodities", "users"
  add_foreign_key "listings", "bids", column: "selected_bid_id"
  add_foreign_key "listings", "commodities"
end
