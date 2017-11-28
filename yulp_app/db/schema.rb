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

ActiveRecord::Schema.define(version: 20171201191730) do

  create_table "business_trains", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.float  "price",    limit: 24
    t.float  "rating",   limit: 24
    t.float  "crowd",    limit: 24
    t.float  "discount", limit: 24
  end

  create_table "categories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "alias"
    t.string "title", null: false
    t.index ["title"], name: "index_categories_on_title", using: :btree
  end

  create_table "categories_restaurants", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "category_id"
    t.integer "restaurant_id"
    t.index ["category_id"], name: "index_categories_restaurants_on_category_id", using: :btree
    t.index ["restaurant_id"], name: "index_categories_restaurants_on_restaurant_id", using: :btree
  end

  create_table "feedbacks", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "subject"
    t.text     "content",    limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "user_id"
    t.index ["user_id"], name: "index_feedbacks_on_user_id", using: :btree
  end

  create_table "preferences", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id",              null: false
    t.integer  "price"
    t.integer  "discount"
    t.integer  "popularity"
    t.integer  "rating"
    t.integer  "crowded"
    t.boolean  "show_rating"
    t.boolean  "show_reviews"
    t.boolean  "show_discount"
    t.boolean  "show_popular_time"
    t.integer  "restaurants_per_page"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.index ["user_id"], name: "index_preferences_on_user_id", unique: true, using: :btree
  end

  create_table "restaurants", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.string   "image_url"
    t.string   "url"
    t.string   "review_count"
    t.float    "rating",        limit: 24
    t.string   "coordinates"
    t.string   "price"
    t.string   "address"
    t.string   "city"
    t.string   "zip_code"
    t.string   "country"
    t.string   "state"
    t.string   "phone"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "name_id"
    t.text     "popular_times", limit: 65535
    t.text     "open_hour",     limit: 65535
    t.integer  "discount"
    t.index ["name_id"], name: "index_restaurants_on_name_id", unique: true, using: :btree
  end

  create_table "reviews", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.float    "rating",         limit: 24
    t.string   "user_image_url"
    t.string   "user_name"
    t.text     "text",           limit: 65535
    t.string   "time_created"
    t.string   "review_url"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "restaurant_id"
    t.integer  "user_id"
    t.index ["restaurant_id"], name: "index_reviews_on_restaurant_id", using: :btree
    t.index ["user_id"], name: "index_reviews_on_user_id", using: :btree
  end

  create_table "search_histories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "query_term"
    t.integer  "times"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
    t.index ["user_id"], name: "index_search_histories_on_user_id", using: :btree
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "password_digest"
    t.string   "provider"
    t.string   "uid"
    t.string   "remember_digest"
    t.string   "oauth_token"
    t.datetime "oauth_expires_at"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
  end

  add_foreign_key "feedbacks", "users"
  add_foreign_key "reviews", "restaurants"
  add_foreign_key "reviews", "users"
  add_foreign_key "search_histories", "users"
end
