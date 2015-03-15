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

ActiveRecord::Schema.define(version: 20150315101403) do

  create_table "approvals", force: true do |t|
    t.integer  "category_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.text     "description"
    t.boolean  "is_writable", default: false
    t.integer  "parent_id"
    t.integer  "group_id"
    t.boolean  "is_featured"
    t.integer  "user_id"
  end

  create_table "documents", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.string   "code"
    t.text     "description"
    t.text     "sample"
    t.date     "start"
    t.date     "end"
    t.string   "source"
    t.integer  "level",       default: 0
    t.integer  "category_id"
    t.integer  "user_id"
  end

  create_table "groups", force: true do |t|
    t.integer  "school_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  add_index "groups", ["school_id"], name: "index_groups_on_school_id"

  create_table "notifications", force: true do |t|
    t.integer  "reason"
    t.boolean  "read"
    t.text     "message"
    t.integer  "user_id"
    t.integer  "from_user_id"
    t.integer  "document_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "requests", force: true do |t|
    t.integer  "owner_id"
    t.integer  "requester_id"
    t.integer  "document_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "requests", ["document_id"], name: "index_requests_on_document_id"
  add_index "requests", ["owner_id"], name: "index_requests_on_owner_id"
  add_index "requests", ["requester_id"], name: "index_requests_on_requester_id"

  create_table "revisions", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "document_id"
    t.integer  "user_id"
    t.integer  "position"
    t.integer  "download_count",                 default: 0
    t.string   "file_name"
    t.string   "file_type"
    t.integer  "file_size"
    t.binary   "file_data",      limit: 4194304
    t.text     "search_text"
    t.string   "doc_link"
  end

  create_table "schools", force: true do |t|
    t.string "name"
  end

  create_table "users", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username"
    t.string   "employee_number"
    t.string   "phone"
    t.string   "mobile"
    t.string   "full_name"
    t.boolean  "is_admin",               default: false
    t.integer  "school_id"
    t.integer  "group_id"
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.boolean  "approved",               default: false, null: false
  end

  add_index "users", ["approved"], name: "index_users_on_approved"
  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
