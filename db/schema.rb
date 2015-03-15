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

ActiveRecord::Schema.define(version: 20150315213208) do

  create_table "api_keys", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "access_token"
    t.integer  "expires_at"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "events", force: :cascade do |t|
    t.string   "name"
    t.string   "organizer"
    t.datetime "date"
    t.string   "location"
    t.string   "description"
    t.string   "image_path"
    t.string   "link"
    t.integer  "total_tickets"
    t.integer  "tickets_sold"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "facebook_identities", force: :cascade do |t|
    t.string   "birthday"
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.string   "name"
    t.string   "username"
    t.string   "location"
    t.string   "link"
    t.string   "facebook_id"
    t.integer  "user_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "facebook_identities", ["user_id"], name: "index_facebook_identities_on_user_id"

  create_table "ticket_statuses", force: :cascade do |t|
    t.string   "name"
    t.integer  "max_purchasable"
    t.integer  "event_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "ticket_statuses", ["event_id"], name: "index_ticket_statuses_on_event_id"

  create_table "tickets", force: :cascade do |t|
    t.integer  "event_id"
    t.integer  "user_id"
    t.string   "status"
    t.integer  "price"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "ticket_status_id"
  end

  add_index "tickets", ["event_id"], name: "index_tickets_on_event_id"
  add_index "tickets", ["ticket_status_id"], name: "index_tickets_on_ticket_status_id"
  add_index "tickets", ["user_id"], name: "index_tickets_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "email"
    t.string   "password"
    t.string   "name"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "cell_phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
