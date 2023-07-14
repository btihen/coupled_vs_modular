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

ActiveRecord::Schema[7.0].define(version: 2023_09_15_080533) do
  create_table "addresses", force: :cascade do |t|
    t.string "street", null: false
    t.string "city", null: false
    t.string "zip", null: false
    t.string "country", null: false
  end

  create_table "passcodes", force: :cascade do |t|
    t.string "name", null: false
    t.string "street", null: false
    t.string "zip", null: false
    t.string "city", null: false
    t.string "country", null: false
    t.integer "passcode", null: false
  end

  create_table "people", force: :cascade do |t|
    t.string "name", null: false
    t.integer "address_id", null: false
    t.index ["address_id"], name: "index_people_on_address_id"
  end

  create_table "securities", force: :cascade do |t|
    t.integer "quantity", null: false
    t.string "ticker", null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_securities_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password", null: false
    t.boolean "is_admin", default: false, null: false
    t.integer "person_id"
    t.index ["person_id"], name: "index_users_on_person_id"
  end

  add_foreign_key "people", "addresses"
  add_foreign_key "securities", "users"
  add_foreign_key "users", "people"
end
