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

ActiveRecord::Schema.define(version: 20140717022103) do

  create_table "collections", force: true do |t|
    t.integer  "user_id"
    t.string   "writer_name"
    t.text     "script"
    t.string   "image_url"
    t.string   "time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "episode_id"
  end

  create_table "comments", force: true do |t|
    t.integer  "episode_id"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  create_table "episodes", force: true do |t|
    t.string   "name"
    t.text     "script"
    t.string   "image_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "good_num"
    t.integer  "bad_num"
    t.integer  "comment_num"
  end

  create_table "estimates", force: true do |t|
    t.integer  "episode_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "messages", force: true do |t|
    t.integer  "owner"
    t.integer  "guest"
    t.text     "content"
    t.boolean  "public"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "settings", force: true do |t|
    t.integer  "owner"
    t.boolean  "history"
    t.boolean  "whisper"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "statistics", force: true do |t|
    t.integer  "good_num"
    t.integer  "bad_num"
    t.integer  "comment_num"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subscriptions", force: true do |t|
    t.integer  "active_id"
    t.integer  "passive_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.string   "remember_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "portrait"
  end

  create_table "whispers", force: true do |t|
    t.integer  "guest"
    t.integer  "owner"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
