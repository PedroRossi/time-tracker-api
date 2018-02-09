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

ActiveRecord::Schema.define(version: 20180208225408) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "project_users", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "project_id"
    t.boolean "owner"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_project_users_on_project_id"
    t.index ["user_id"], name: "index_project_users_on_user_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "timelogs", force: :cascade do |t|
    t.string "description"
    t.float "time"
    t.bigint "project_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "finished", default: false
    t.boolean "paused", default: false
    t.index ["project_id"], name: "index_timelogs_on_project_id"
    t.index ["user_id"], name: "index_timelogs_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "photo"
    t.boolean "isOwner", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "accepted", default: false
    t.string "uid"
    t.string "provider"
  end

  add_foreign_key "project_users", "projects"
  add_foreign_key "project_users", "users"
  add_foreign_key "timelogs", "projects"
  add_foreign_key "timelogs", "users"
end
