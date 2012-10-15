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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121015052131) do

  create_table "apps", :force => true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "githubname"
    t.string   "githubproject"
    t.string   "virtual_name"
  end

  create_table "collaborators", :force => true do |t|
    t.integer  "apps_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "servers", :force => true do |t|
    t.string   "devserver"
    t.string   "prodserver"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "apps_id"
    t.string   "devurl"
    t.string   "produrl"
  end

  create_table "thedatabases", :force => true do |t|
    t.string   "database_username"
    t.string   "database_name"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.integer  "apps_id"
    t.string   "database_pwd"
  end

  create_table "userkeys", :force => true do |t|
    t.text     "userkey"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "password"
    t.string   "email"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
