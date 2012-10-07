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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121005081419) do

  create_table "albums", :force => true do |t|
    t.string   "name"
    t.date     "releasedate"
    t.string   "catalognumber"
    t.string   "genre"
    t.string   "classification"
    t.boolean  "obtained"
    t.string   "reference"
    t.string   "albumart"
    t.text     "note"
    t.integer  "publisher_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "albums", ["created_at"], :name => "index_albums_on_created_at"
  add_index "albums", ["id"], :name => "index_albums_on_id"
  add_index "albums", ["name"], :name => "index_albums_on_name"
  add_index "albums", ["releasedate"], :name => "index_albums_on_releasedate"
  add_index "albums", ["updated_at"], :name => "index_albums_on_updated_at"

  create_table "albums_arrangers", :id => false, :force => true do |t|
    t.integer "album_id"
    t.integer "artist_id"
  end

  create_table "albums_composers", :id => false, :force => true do |t|
    t.integer "album_id"
    t.integer "artist_id"
  end

  create_table "albums_performers", :id => false, :force => true do |t|
    t.integer "album_id"
    t.integer "artist_id"
  end

  create_table "albums_sources", :id => false, :force => true do |t|
    t.integer "album_id"
    t.integer "source_id"
  end

  create_table "aliases", :force => true do |t|
    t.integer  "parent_id"
    t.integer  "alias_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "artists", :force => true do |t|
    t.string   "name"
    t.string   "reference"
    t.string   "activity"
    t.string   "database_activity"
    t.boolean  "obtained"
    t.text     "note"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "artists", ["database_activity"], :name => "index_artists_on_database_activity"
  add_index "artists", ["id"], :name => "index_artists_on_id"
  add_index "artists", ["name"], :name => "index_artists_on_name"

  create_table "franchises", :force => true do |t|
    t.integer  "franchise_id"
    t.integer  "instance_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "publishers", :force => true do |t|
    t.string   "name"
    t.string   "reference"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "publishers", ["id"], :name => "index_publishers_on_id"
  add_index "publishers", ["name"], :name => "index_publishers_on_name"

  create_table "sources", :force => true do |t|
    t.string   "name"
    t.string   "reference"
    t.string   "activity"
    t.string   "database_activity"
    t.boolean  "obtained"
    t.text     "note"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "sources", ["database_activity"], :name => "index_sources_on_database_activity"
  add_index "sources", ["id"], :name => "index_sources_on_id"
  add_index "sources", ["name"], :name => "index_sources_on_name"

  create_table "units", :force => true do |t|
    t.integer  "unit_id"
    t.integer  "member_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
