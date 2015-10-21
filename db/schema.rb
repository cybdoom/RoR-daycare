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

ActiveRecord::Schema.define(version: 20151021185507) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "children", force: :cascade do |t|
    t.string   "name"
    t.integer  "daycare_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "children", ["daycare_id"], name: "index_children_on_daycare_id", using: :btree

  create_table "customer_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "daycare_todos", force: :cascade do |t|
    t.integer  "todo_id"
    t.integer  "daycare_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "daycare_todos", ["daycare_id"], name: "index_daycare_todos_on_daycare_id", using: :btree
  add_index "daycare_todos", ["todo_id"], name: "index_daycare_todos_on_todo_id", using: :btree

  create_table "daycares", force: :cascade do |t|
    t.string   "name"
    t.string   "address_line1"
    t.string   "post_code"
    t.string   "country"
    t.string   "telephone"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "customer_type_id"
    t.string   "language"
  end

  create_table "department_todos", force: :cascade do |t|
    t.integer  "todo_id"
    t.integer  "department_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "department_todos", ["department_id"], name: "index_department_todos_on_department_id", using: :btree
  add_index "department_todos", ["todo_id"], name: "index_department_todos_on_todo_id", using: :btree

  create_table "departments", force: :cascade do |t|
    t.string   "department_name"
    t.integer  "daycare_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "departments", ["daycare_id"], name: "index_departments_on_daycare_id", using: :btree

  create_table "devices", force: :cascade do |t|
    t.string   "device_token"
    t.string   "device_type"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "key_tasks", force: :cascade do |t|
    t.string   "name"
    t.integer  "key_task_id"
    t.integer  "todo_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "key_tasks", ["key_task_id"], name: "index_key_tasks_on_key_task_id", using: :btree
  add_index "key_tasks", ["todo_id"], name: "index_key_tasks_on_todo_id", using: :btree

  create_table "occurrences", force: :cascade do |t|
    t.integer  "todo_id"
    t.datetime "schedule_date"
    t.datetime "due_date"
    t.string   "status"
    t.datetime "submitted_at"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "occurrences", ["todo_id"], name: "index_occurrences_on_todo_id", using: :btree

  create_table "permissions", force: :cascade do |t|
    t.integer  "daycare_id"
    t.string   "user_type"
    t.string   "functionality_type"
    t.string   "type"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "permissions", ["daycare_id"], name: "index_permissions_on_daycare_id", using: :btree

  create_table "photos", force: :cascade do |t|
    t.integer  "photoable_id"
    t.string   "photoable_type"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.integer  "daycare_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "roles", ["daycare_id"], name: "index_roles_on_daycare_id", using: :btree

  create_table "todos", force: :cascade do |t|
    t.string   "title"
    t.datetime "schedule_date"
    t.datetime "due_date"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.boolean  "is_delegatable",  default: false
    t.boolean  "is_circulatable", default: false
    t.string   "todo_for"
    t.string   "status",          default: "pending"
    t.integer  "acceptor_id"
    t.integer  "daycare_id"
    t.string   "frequency"
    t.string   "recurring_rule"
    t.datetime "until"
  end

  add_index "todos", ["daycare_id"], name: "index_todos_on_daycare_id", using: :btree

  create_table "user_devices", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.integer  "device_id",  null: false
    t.string   "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_todos", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "todo_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "user_todos", ["todo_id"], name: "index_user_todos_on_todo_id", using: :btree
  add_index "user_todos", ["user_id"], name: "index_user_todos_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.integer  "role_id"
    t.integer  "daycare_id"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type"
    t.string   "name"
    t.string   "set_password_token"
    t.string   "api_key"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "children", "daycares"
  add_foreign_key "daycare_todos", "daycares"
  add_foreign_key "daycare_todos", "todos"
  add_foreign_key "department_todos", "departments"
  add_foreign_key "department_todos", "todos"
  add_foreign_key "departments", "daycares"
  add_foreign_key "key_tasks", "key_tasks"
  add_foreign_key "key_tasks", "todos"
  add_foreign_key "occurrences", "todos"
  add_foreign_key "permissions", "daycares"
  add_foreign_key "roles", "daycares"
  add_foreign_key "todos", "daycares"
  add_foreign_key "user_todos", "todos"
  add_foreign_key "user_todos", "users"
end
