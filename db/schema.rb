# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_03_04_083215) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "boards", force: :cascade do |t|
    t.string "title"
    t.string "describe"
    t.boolean "archived", default: false
    t.integer "background_color", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "owner_id"
    t.index ["owner_id"], name: "index_boards_on_owner_id"
  end

  create_table "comments", force: :cascade do |t|
    t.string "author"
    t.string "body"
    t.bigint "todopoint_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["todopoint_id"], name: "index_comments_on_todopoint_id"
  end

  create_table "lists", force: :cascade do |t|
    t.string "title"
    t.boolean "done", default: false
    t.bigint "board_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["board_id"], name: "index_lists_on_board_id"
  end

  create_table "members", force: :cascade do |t|
    t.integer "board_id"
    t.integer "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "todopoints", force: :cascade do |t|
    t.string "body"
    t.boolean "done", default: false
    t.integer "position"
    t.bigint "list_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["list_id"], name: "index_todopoints_on_list_id"
  end

  create_table "tokens", force: :cascade do |t|
    t.string "value"
    t.string "email"
    t.boolean "used", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "type", null: false
    t.integer "target_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "nickname"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "confirmed_at", precision: 6
  end

end
