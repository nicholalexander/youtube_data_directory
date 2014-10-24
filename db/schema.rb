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

ActiveRecord::Schema.define(version: 20141024202809) do

  create_table "channels", force: true do |t|
    t.string  "name"
    t.integer "view_count"
    t.integer "comment_count"
    t.integer "subscriber_count"
    t.boolean "hidden_subscriber_count"
    t.integer "video_count"
    t.string  "channel_id"
    t.string  "channel_etag"
    t.string  "category_id"
  end

end
