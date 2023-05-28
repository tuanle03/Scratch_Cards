# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_05_27_183441) do
  create_table "cards", force: :cascade do |t|
    t.integer "point"
    t.string "name"
    t.string "suit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "game_player_cards", force: :cascade do |t|
    t.integer "game_player_id"
    t.integer "card_id"
    t.string "option"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "game_players", force: :cascade do |t|
    t.integer "game_id"
    t.integer "player_id"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "games", force: :cascade do |t|
    t.integer "room_id"
    t.integer "bookmaker_id"
    t.integer "current_bets"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rooms", force: :cascade do |t|
    t.integer "bookmaker_id"
    t.string "name"
    t.string "code"
    t.string "password"
    t.integer "bets"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "players"
    t.integer "current_players"
  end

  create_table "user_rooms", force: :cascade do |t|
    t.integer "user_id"
    t.integer "room_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "username"
    t.string "gender"
    t.integer "coins"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "current_room_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
