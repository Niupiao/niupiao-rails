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

ActiveRecord::Schema.define(version: 20150215014714) do

  create_table "events", force: :cascade do |t|
    t.string   "name"
    t.string   "organizer"
    t.date     "date"
    t.string   "location"
    t.string   "description"
    t.string   "link"
    t.integer  "total_tickets"
    t.integer  "tickets_sold"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "tickets", force: :cascade do |t|
    t.integer  "event_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "tickets", ["event_id"], name: "index_tickets_on_event_id"
  add_index "tickets", ["user_id"], name: "index_tickets_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "unix"
    t.string   "password"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
