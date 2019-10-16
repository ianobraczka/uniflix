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

ActiveRecord::Schema.define(version: 2019_10_16_125659) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "intarray"
  enable_extension "plpgsql"

  create_table "books", force: :cascade do |t|
    t.string "author"
    t.integer "height"
    t.string "publisher"
    t.bigint "category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "genre"
    t.string "title"
    t.index ["category_id"], name: "index_books_on_category_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "colab_based_recommendations", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "movies_ids", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "updated"
    t.index ["user_id"], name: "index_colab_based_recommendations_on_user_id"
  end

  create_table "content_based_recommendations", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "movies_ids", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "updated"
    t.index ["user_id"], name: "index_content_based_recommendations_on_user_id"
  end

  create_table "content_recommendations", force: :cascade do |t|
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_content_recommendations_on_user_id"
  end

  create_table "likes", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "book_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["book_id"], name: "index_likes_on_book_id"
    t.index ["user_id"], name: "index_likes_on_user_id"
  end

  create_table "movies", force: :cascade do |t|
    t.integer "old_id"
    t.string "title"
    t.string "date"
    t.string "poster_path"
    t.float "vote_avg"
    t.integer "vote_count"
    t.bigint "category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_movies_on_category_id"
  end

  create_table "past_based_recommendations", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "movies_ids", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "updated"
    t.index ["user_id"], name: "index_past_based_recommendations_on_user_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "movie_id"
    t.integer "rating"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["movie_id"], name: "index_reviews_on_movie_id"
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "old_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "books", "categories"
  add_foreign_key "colab_based_recommendations", "users"
  add_foreign_key "content_based_recommendations", "users"
  add_foreign_key "content_recommendations", "users"
  add_foreign_key "likes", "books"
  add_foreign_key "likes", "users"
  add_foreign_key "movies", "categories"
  add_foreign_key "past_based_recommendations", "users"
  add_foreign_key "reviews", "movies"
  add_foreign_key "reviews", "users"
end
