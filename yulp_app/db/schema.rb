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

ActiveRecord::Schema.define(version: 20171019191344) do

  create_table "business_trains", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.float  "price",    limit: 24
    t.float  "rating",   limit: 24
    t.float  "crowd",    limit: 24
    t.float  "discount", limit: 24
  end

  create_table "categories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "description"
  end

  create_table "restaurants", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.string   "image_url"
    t.string   "url"
    t.string   "review_count"
    t.string   "categories"
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
    t.index ["restaurant_id"], name: "index_reviews_on_restaurant_id", using: :btree
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

  add_foreign_key "reviews", "restaurants"
end
