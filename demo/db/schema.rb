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

ActiveRecord::Schema.define(version: 20180216085616) do

  create_table "comments", force: :cascade do |t|
    t.integer "micropost_id"
    t.string "from"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["micropost_id"], name: "index_comments_on_micropost_id"
  end

  create_table "messages", force: :cascade do |t|
    t.text "content"
    t.integer "from_id"
    t.integer "to_id"
    t.string "room_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["room_id", "created_at"], name: "index_messages_on_room_id_and_created_at"
  end

  create_table "microposts", force: :cascade do |t|
    t.text "content"
    t.integer "person_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "picture"
    t.index ["person_id", "created_at"], name: "index_microposts_on_person_id_and_created_at"
    t.index ["person_id"], name: "index_microposts_on_person_id"
  end

  create_table "people", force: :cascade do |t|
    t.string "handlename"
    t.boolean "sex"
    t.integer "syear"
    t.string "bplace"
    t.string "name"
    t.string "email"
    t.string "tel"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.string "remember_digest"
    t.boolean "admin", default: false
    t.string "activation_digest"
    t.boolean "activated", default: false
    t.datetime "activated_at"
    t.string "reset_digest"
    t.integer "point", default: 0
    t.integer "count", default: 0
    t.index ["email"], name: "index_People_on_email", unique: true
  end

  create_table "relationships", force: :cascade do |t|
    t.integer "personA_id"
    t.integer "personB_id"
    t.integer "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "sendA", default: false
    t.boolean "sendB", default: false
    t.boolean "waitA", default: false
    t.boolean "waitB", default: false
    t.integer "disclosure", default: 0
    t.index ["disclosure"], name: "index_relationships_on_disclosure"
    t.index ["personA_id", "personB_id"], name: "index_relationships_on_personA_id_and_personB_id", unique: true
    t.index ["personA_id"], name: "index_relationships_on_personA_id"
    t.index ["personB_id"], name: "index_relationships_on_personB_id"
    t.index ["sendA"], name: "index_relationships_on_sendA"
    t.index ["sendB"], name: "index_relationships_on_sendB"
    t.index ["value"], name: "index_relationships_on_value"
    t.index ["waitA"], name: "index_relationships_on_waitA"
    t.index ["waitB"], name: "index_relationships_on_waitB"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.string "remember_digest"
    t.boolean "admin", default: false
    t.string "activation_digest"
    t.boolean "activated", default: false
    t.datetime "activated_at"
    t.string "reset_digest"
    t.datetime "reset_sent_at"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
