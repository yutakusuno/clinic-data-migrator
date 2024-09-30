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

ActiveRecord::Schema[7.2].define(version: 2024_09_29_005315) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.bigint "patient_id", null: false
    t.string "address_1"
    t.string "address_2"
    t.string "province"
    t.string "city"
    t.string "postal_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["patient_id"], name: "index_addresses_on_patient_id"
  end

  create_table "file_migrations", force: :cascade do |t|
    t.string "file_name", null: false
    t.datetime "start_time", null: false
    t.datetime "end_time"
    t.integer "imported_count", default: 0
    t.text "migration_errors"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "health_identifiers", force: :cascade do |t|
    t.bigint "patient_id", null: false
    t.string "identifier_number", null: false
    t.string "province_of_origin", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identifier_number", "province_of_origin"], name: "idx_on_identifier_number_province_of_origin_3042b0d690", unique: true
    t.index ["patient_id"], name: "index_health_identifiers_on_patient_id"
  end

  create_table "patients", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "middle_name"
    t.string "phone_number", null: false
    t.string "email"
    t.date "date_of_birth", null: false
    t.string "sex", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "vitals", force: :cascade do |t|
    t.bigint "patient_id", null: false
    t.string "vital_type", null: false
    t.decimal "measurement", precision: 10, scale: 2, null: false
    t.string "units", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["patient_id"], name: "index_vitals_on_patient_id"
  end

  add_foreign_key "addresses", "patients"
  add_foreign_key "health_identifiers", "patients"
  add_foreign_key "vitals", "patients"
end
