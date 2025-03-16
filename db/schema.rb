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

ActiveRecord::Schema[7.0].define(version: 2025_03_16_170329) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest", null: false
    t.string "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "workout_sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "type_id"
    t.bigint "user_id"
    t.integer "duration"
    t.text "notes"
    t.datetime "start_time"
    t.datetime "end_time"
    t.index ["type_id"], name: "index_workout_sessions_on_type_id"
    t.index ["user_id"], name: "index_workout_sessions_on_user_id"
  end

  create_table "workout_types", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.string "description"
    t.datetime "disabled_at"
  end

  add_foreign_key "workout_sessions", "workout_types", column: "type_id"
end
