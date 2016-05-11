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

ActiveRecord::Schema.define(version: 20160327082349) do

  create_table "average_caches", force: :cascade do |t|
    t.integer  "rater_id"
    t.integer  "rateable_id"
    t.string   "rateable_type"
    t.float    "avg",           null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "companies", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.text     "as_is_diagram"
    t.text     "final_diagram"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "overall_averages", force: :cascade do |t|
    t.integer  "rateable_id"
    t.string   "rateable_type"
    t.float    "overall_avg",   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "practices", force: :cascade do |t|
    t.string   "name"
    t.string   "question"
    t.text     "examples"
    t.integer  "added_value"
    t.integer  "specific_goals_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "process_areas", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.string   "purpose"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "rates", force: :cascade do |t|
    t.integer  "rater_id"
    t.integer  "rateable_id"
    t.string   "rateable_type"
    t.float    "stars",         null: false
    t.string   "dimension"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rates", ["rateable_id", "rateable_type"], name: "index_rates_on_rateable_id_and_rateable_type"
  add_index "rates", ["rater_id"], name: "index_rates_on_rater_id"

  create_table "rating_caches", force: :cascade do |t|
    t.integer  "cacheable_id"
    t.string   "cacheable_type"
    t.float    "avg",            null: false
    t.integer  "qty",            null: false
    t.string   "dimension"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rating_caches", ["cacheable_id", "cacheable_type"], name: "index_rating_caches_on_cacheable_id_and_cacheable_type"

  create_table "specific_goals", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "process_areas_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "user_practices", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "practice_id"
    t.integer  "answer"
    t.float    "added_value", default: 0.0
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "user_practices", ["practice_id"], name: "index_user_practices_on_practice_id"
  add_index "user_practices", ["user_id"], name: "index_user_practices_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "last_name"
    t.integer  "position"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "company_id"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
