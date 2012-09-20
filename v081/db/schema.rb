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

ActiveRecord::Schema.define(:version => 20120331142449) do

  create_table "custacts", :id => false, :force => true do |t|
    t.integer   "id",                              :precision => 38, :scale => 0
    t.integer   "custinsts_id",                    :precision => 38, :scale => 0
    t.timestamp "actdate",         :limit => 6
    t.timestamp "inputdate",       :limit => 6
    t.decimal   "qty",                             :precision => 16, :scale => 4
    t.decimal   "price",                           :precision => 16, :scale => 4
    t.decimal   "amt",                             :precision => 16, :scale => 4
    t.string    "sno",             :limit => 40
    t.integer   "lineno",          :limit => 4,    :precision => 4,  :scale => 0
    t.integer   "persons_id_chrg",                 :precision => 38, :scale => 0
    t.string    "infomation",      :limit => 2000
    t.string    "remark",          :limit => 200
    t.integer   "persons_id_upd",                  :precision => 38, :scale => 0
    t.string    "update_ip",       :limit => 40
    t.timestamp "created_at",      :limit => 6
    t.timestamp "updated_at",      :limit => 6
  end

  create_table "custfrcs", :id => false, :force => true do |t|
    t.integer   "id",                              :precision => 38, :scale => 0
    t.integer   "custs_id",                        :precision => 38, :scale => 0
    t.integer   "itms_id",                         :precision => 38, :scale => 0
    t.string    "sno",             :limit => 40
    t.integer   "lineno",          :limit => 4,    :precision => 4,  :scale => 0
    t.integer   "persons_id_chrg",                 :precision => 38, :scale => 0
    t.timestamp "duedate",         :limit => 6
    t.timestamp "frcdate",         :limit => 6
    t.decimal   "qty",                             :precision => 16, :scale => 4
    t.decimal   "price",                           :precision => 16, :scale => 4
    t.decimal   "amt",                             :precision => 16, :scale => 4
    t.string    "infomation",      :limit => 2000
    t.string    "remark",          :limit => 200
    t.datetime  "expiredate"
    t.integer   "persons_id_upd",                  :precision => 38, :scale => 0
    t.string    "update_ip",       :limit => 40
    t.timestamp "created_at",      :limit => 6
    t.timestamp "updated_at",      :limit => 6
  end

  create_table "custinsts", :id => false, :force => true do |t|
    t.integer   "id",                              :precision => 38, :scale => 0
    t.integer   "custords_id",                     :precision => 38, :scale => 0
    t.integer   "custrcvplcs_id",                  :precision => 38, :scale => 0
    t.integer   "shpschs_id",                      :precision => 38, :scale => 0
    t.timestamp "duedate",         :limit => 6
    t.timestamp "instdate",        :limit => 6
    t.decimal   "qty",                             :precision => 16, :scale => 4
    t.decimal   "price",                           :precision => 16, :scale => 4
    t.decimal   "amt",                             :precision => 16, :scale => 4
    t.string    "sno",             :limit => 40
    t.integer   "lineno",          :limit => 4,    :precision => 4,  :scale => 0
    t.integer   "persons_id_chrg",                 :precision => 38, :scale => 0
    t.string    "infomation",      :limit => 2000
    t.string    "remark",          :limit => 200
    t.integer   "persons_id_upd",                  :precision => 38, :scale => 0
    t.string    "update_ip",       :limit => 40
    t.timestamp "created_at",      :limit => 6
    t.timestamp "updated_at",      :limit => 6
  end

  create_table "custords", :id => false, :force => true do |t|
    t.integer   "id",                              :precision => 38, :scale => 0
    t.integer   "custs_id",                        :precision => 38, :scale => 0
    t.integer   "itms_id",                         :precision => 38, :scale => 0
    t.integer   "persons_id_chrg",                 :precision => 38, :scale => 0
    t.timestamp "duedate",         :limit => 6
    t.timestamp "ordsdate",        :limit => 6
    t.decimal   "qty",                             :precision => 16, :scale => 4
    t.decimal   "price",                           :precision => 16, :scale => 4
    t.decimal   "amt",                             :precision => 16, :scale => 4
    t.string    "sno",             :limit => 40
    t.integer   "lineno",          :limit => 4,    :precision => 4,  :scale => 0
    t.string    "infomation",      :limit => 2000
    t.string    "remark",          :limit => 200
    t.datetime  "expiredate"
    t.integer   "persons_id_upd",                  :precision => 38, :scale => 0
    t.string    "update_ip",       :limit => 40
    t.timestamp "created_at",      :limit => 6
    t.timestamp "updated_at",      :limit => 6
  end

  create_table "custplns", :id => false, :force => true do |t|
    t.integer   "id",                              :precision => 38, :scale => 0
    t.integer   "custs_id",                        :precision => 38, :scale => 0
    t.integer   "itms_id",                         :precision => 38, :scale => 0
    t.string    "sno",             :limit => 40
    t.integer   "lineno",          :limit => 4,    :precision => 4,  :scale => 0
    t.integer   "persons_id_chrg",                 :precision => 38, :scale => 0
    t.timestamp "duedate",         :limit => 6
    t.timestamp "plndate",         :limit => 6
    t.decimal   "qty",                             :precision => 16, :scale => 4
    t.decimal   "price",                           :precision => 16, :scale => 4
    t.decimal   "amt",                             :precision => 16, :scale => 4
    t.string    "infomation",      :limit => 2000
    t.string    "remark",          :limit => 200
    t.datetime  "expiredate"
    t.integer   "persons_id_upd",                  :precision => 38, :scale => 0
    t.string    "update_ip",       :limit => 40
    t.timestamp "created_at",      :limit => 6
    t.timestamp "updated_at",      :limit => 6
  end

  create_table "entprcusts", :id => false, :force => true do |t|
    t.integer   "id",                        :precision => 38, :scale => 0
    t.integer   "entprs_id",                 :precision => 38, :scale => 0
    t.integer   "custs_id",                  :precision => 38, :scale => 0
    t.datetime  "expiredate"
    t.string    "remark",     :limit => 200
    t.string    "update_ip",  :limit => 40
    t.timestamp "created_at", :limit => 6
    t.timestamp "updated_at", :limit => 6
  end

  create_table "prcacts", :id => false, :force => true do |t|
    t.integer   "id",                             :precision => 38, :scale => 0
    t.string    "sno",             :limit => 40
    t.integer   "lineno",          :limit => 4,   :precision => 4,  :scale => 0
    t.integer   "prcinsts_id",                    :precision => 38, :scale => 0
    t.integer   "persons_id_chrg",                :precision => 38, :scale => 0
    t.timestamp "actdate",         :limit => 6
    t.timestamp "inputdate",       :limit => 6
    t.decimal   "qty",                            :precision => 16, :scale => 4
    t.string    "remark",          :limit => 200
    t.string    "update_ip",       :limit => 40
    t.timestamp "created_at",      :limit => 6
    t.timestamp "updated_at",      :limit => 6
  end

  create_table "prcfrcs", :id => false, :force => true do |t|
    t.integer   "id",                              :precision => 38, :scale => 0
    t.integer   "opeitms_id",                      :precision => 38, :scale => 0
    t.string    "sno",             :limit => 40
    t.integer   "lineno",          :limit => 4,    :precision => 4,  :scale => 0
    t.integer   "persons_id_chrg",                 :precision => 38, :scale => 0
    t.timestamp "duedate",         :limit => 6
    t.timestamp "frcdate",         :limit => 6
    t.decimal   "qty",                             :precision => 16, :scale => 4
    t.decimal   "price",                           :precision => 16, :scale => 4
    t.decimal   "amt",                             :precision => 16, :scale => 4
    t.string    "infomation",      :limit => 2000
    t.string    "remark",          :limit => 200
    t.string    "update_ip",       :limit => 40
    t.timestamp "created_at",      :limit => 6
    t.timestamp "updated_at",      :limit => 6
  end

  create_table "prcinsts", :id => false, :force => true do |t|
    t.integer   "id",                             :precision => 38, :scale => 0
    t.string    "sno",             :limit => 40
    t.integer   "lineno",          :limit => 4,   :precision => 4,  :scale => 0
    t.integer   "prcords_id",                     :precision => 38, :scale => 0
    t.integer   "persons_id_chrg",                :precision => 38, :scale => 0
    t.timestamp "instdate",        :limit => 6
    t.timestamp "duedate",         :limit => 6
    t.decimal   "qty",                            :precision => 16, :scale => 4
    t.decimal   "price",                          :precision => 16, :scale => 4
    t.decimal   "amt",                            :precision => 16, :scale => 4
    t.string    "remark",          :limit => 200
    t.string    "update_ip",       :limit => 40
    t.timestamp "created_at",      :limit => 6
    t.timestamp "updated_at",      :limit => 6
  end

  create_table "prcplns", :id => false, :force => true do |t|
    t.integer   "id",                              :precision => 38, :scale => 0
    t.integer   "opeitms_id",                      :precision => 38, :scale => 0
    t.integer   "prcschs_id",                      :precision => 38, :scale => 0
    t.string    "sno",             :limit => 40
    t.integer   "lineno",          :limit => 4,    :precision => 4,  :scale => 0
    t.integer   "persons_id_chrg",                 :precision => 38, :scale => 0
    t.timestamp "duedate",         :limit => 6
    t.timestamp "plndate",         :limit => 6
    t.decimal   "qty",                             :precision => 16, :scale => 4
    t.decimal   "price",                           :precision => 16, :scale => 4
    t.decimal   "amt",                             :precision => 16, :scale => 4
    t.string    "infomation",      :limit => 2000
    t.string    "remark",          :limit => 200
    t.string    "update_ip",       :limit => 40
    t.timestamp "created_at",      :limit => 6
    t.timestamp "updated_at",      :limit => 6
  end

  create_table "shpinsts", :id => false, :force => true do |t|
    t.integer   "id",                             :precision => 38, :scale => 0
    t.string    "sno",             :limit => 40
    t.integer   "lineno",          :limit => 4,   :precision => 4,  :scale => 0
    t.integer   "shpords_id",                     :precision => 38, :scale => 0
    t.timestamp "duedate",         :limit => 6
    t.decimal   "qty",                            :precision => 16, :scale => 4
    t.decimal   "weight",                         :precision => 16, :scale => 4
    t.decimal   "volume",                         :precision => 16, :scale => 4
    t.integer   "carton",          :limit => 4,   :precision => 4,  :scale => 0
    t.string    "remark",          :limit => 200
    t.string    "transport_id",    :limit => 200
    t.integer   "persons_id_chrg",                :precision => 38, :scale => 0
    t.integer   "persons_id_upd",                 :precision => 38, :scale => 0
    t.string    "update_ip",       :limit => 40
    t.timestamp "created_at",      :limit => 6
    t.timestamp "updated_at",      :limit => 6
  end

  create_table "shpords", :id => false, :force => true do |t|
    t.integer   "id",                             :precision => 38, :scale => 0
    t.integer   "shpschs_id",                     :precision => 38, :scale => 0
    t.string    "sno",             :limit => 40
    t.integer   "lineno",          :limit => 4,   :precision => 4,  :scale => 0
    t.timestamp "ordsdate",        :limit => 6
    t.string    "ordno",           :limit => 40
    t.timestamp "duedate",         :limit => 6
    t.decimal   "qty",                            :precision => 16, :scale => 4
    t.decimal   "weight",                         :precision => 16, :scale => 4
    t.decimal   "volume",                         :precision => 16, :scale => 4
    t.integer   "carton",          :limit => 4,   :precision => 4,  :scale => 0
    t.string    "remark",          :limit => 200
    t.integer   "persons_id_chrg",                :precision => 38, :scale => 0
    t.integer   "persons_id_upd",                 :precision => 38, :scale => 0
    t.string    "update_ip",       :limit => 40
    t.timestamp "created_at",      :limit => 6
    t.timestamp "updated_at",      :limit => 6
  end

  create_table "shpschs", :id => false, :force => true do |t|
    t.integer   "id",                           :precision => 38, :scale => 0
    t.integer   "itms_id",                      :precision => 38, :scale => 0
    t.timestamp "duedate",       :limit => 6
    t.integer   "locas_id_from",                :precision => 38, :scale => 0
    t.decimal   "qty",                          :precision => 16, :scale => 4
    t.integer   "carton",        :limit => 4,   :precision => 4,  :scale => 0
    t.decimal   "weight",                       :precision => 16, :scale => 4
    t.decimal   "volume",                       :precision => 16, :scale => 4
    t.string    "remark",        :limit => 200
    t.string    "update_ip",     :limit => 40
    t.timestamp "created_at",    :limit => 6
    t.timestamp "updated_at",    :limit => 6
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                                 :default => "", :null => false
    t.string   "encrypted_password",                                    :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :precision => 38, :scale => 0, :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "i_users_reset_password_token", :unique => true

end
