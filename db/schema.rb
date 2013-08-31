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

ActiveRecord::Schema.define(:version => 20130831150807) do

  create_table "apps", :force => true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.string   "githubname"
    t.string   "githubproject"
    t.string   "virtual_name"
    t.integer  "githubrepo",    :default => 1, :null => false
    t.string   "type_server"
  end

  create_table "apps_notifs", :force => true do |t|
    t.integer  "apps_id"
    t.integer  "notif_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "collaborators", :force => true do |t|
    t.integer  "apps_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "notifs", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.string   "committer"
    t.string   "date"
    t.string   "commit_message"
  end

  create_table "notifs_users", :force => true do |t|
    t.integer  "notif_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "apps_id"
  end

  create_table "servers", :force => true do |t|
    t.string   "devserver"
    t.string   "prodserver"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "apps_id"
    t.string   "devurl"
    t.string   "produrl"
    t.string   "sftp_username"
    t.string   "sftp_password"
    t.string   "sftp_host"
    t.string   "sftp_location"
  end

  create_table "thedatabases", :force => true do |t|
    t.string   "database_username"
    t.string   "database_name"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.integer  "apps_id"
    t.string   "database_pwd"
  end

  create_table "updateapps", :force => true do |t|
    t.integer  "apps_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.boolean  "updated"
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
