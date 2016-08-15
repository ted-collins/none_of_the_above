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

ActiveRecord::Schema.define(version: 20160815182636) do

  create_table "charts", force: :cascade do |t|
    t.string   "name",                      limit: 255
    t.integer  "chart_type",                limit: 4
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.string   "static_image_file_name",    limit: 255
    t.string   "static_image_content_type", limit: 255
    t.integer  "static_image_file_size",    limit: 4
    t.datetime "static_image_updated_at"
  end

  create_table "generators", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "recommenders", force: :cascade do |t|
    t.integer  "user_id",         limit: 4,                null: false
    t.string   "email",           limit: 255, default: "", null: false
    t.datetime "originally_sent"
    t.string   "response_token",  limit: 255
    t.integer  "nag_count",       limit: 4
    t.datetime "last_nagged_at"
    t.string   "response",        limit: 255
    t.datetime "responded_at"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
  end

  add_index "recommenders", ["email"], name: "index_recommenders_on_email", using: :btree
  add_index "recommenders", ["response_token"], name: "index_recommenders_on_response_token", unique: true, using: :btree
  add_index "recommenders", ["user_id"], name: "index_recommenders_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",      limit: 255
    t.integer  "failed_attempts",        limit: 4,   default: 0,  null: false
    t.string   "unlock_token",           limit: 255
    t.datetime "locked_at"
    t.string   "party_affiliation",      limit: 255
    t.string   "zipcode",                limit: 255
    t.string   "place_name",             limit: 255
    t.string   "state_abbreviation",     limit: 255
    t.string   "locale",                 limit: 255
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["party_affiliation"], name: "index_users_on_party_affiliation", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["state_abbreviation"], name: "index_users_on_state_abbreviation", using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree
  add_index "users", ["zipcode"], name: "index_users_on_zipcode", using: :btree

end
