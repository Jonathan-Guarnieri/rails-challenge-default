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

ActiveRecord::Schema.define(version: 2024_05_19_130746) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "users", force: :cascade do |t|
    t.string "email", limit: 200, null: false
    t.string "phone_number", limit: 20, null: false
    t.string "full_name", limit: 200
    t.string "password", limit: 100, null: false
    t.string "key", limit: 100, null: false
    t.string "account_key", limit: 100
    t.string "metadata", limit: 2000
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_key"], name: "index_users_on_account_key", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["key"], name: "index_users_on_key", unique: true
    t.index ["phone_number"], name: "index_users_on_phone_number", unique: true
  end

end
