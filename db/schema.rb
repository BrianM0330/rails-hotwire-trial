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

ActiveRecord::Schema[8.1].define(version: 2026_05_15_183100) do
  create_table "comments", force: :cascade do |t|
    t.text "body", null: false
    t.datetime "created_at", null: false
    t.integer "photo_id", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["photo_id", "created_at"], name: "index_comments_on_photo_id_and_created_at"
    t.index ["photo_id"], name: "index_comments_on_photo_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "likes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "photo_id", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["photo_id"], name: "index_likes_on_photo_id"
    t.index ["user_id", "photo_id"], name: "index_likes_on_user_id_and_photo_id", unique: true
    t.index ["user_id"], name: "index_likes_on_user_id"
  end

  create_table "photos", force: :cascade do |t|
    t.text "alt", null: false
    t.string "avg_color", null: false
    t.integer "comments_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.integer "height", null: false
    t.integer "likes_count", default: 0, null: false
    t.integer "pexels_id", null: false
    t.string "photographer", null: false
    t.integer "photographer_id", null: false
    t.string "photographer_url", null: false
    t.datetime "updated_at", null: false
    t.string "url", null: false
    t.integer "width", null: false
    t.index ["pexels_id"], name: "index_photos_on_pexels_id", unique: true
    t.check_constraint "comments_count >= 0", name: "photos_comments_count_non_negative"
    t.check_constraint "height > 0", name: "photos_height_positive"
    t.check_constraint "likes_count >= 0", name: "photos_likes_count_non_negative"
    t.check_constraint "pexels_id > 0", name: "photos_pexels_id_positive"
    t.check_constraint "photographer_id > 0", name: "photos_photographer_id_positive"
    t.check_constraint "width > 0", name: "photos_width_positive"
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  add_foreign_key "comments", "photos"
  add_foreign_key "comments", "users"
  add_foreign_key "likes", "photos"
  add_foreign_key "likes", "users"
  add_foreign_key "sessions", "users"
end
