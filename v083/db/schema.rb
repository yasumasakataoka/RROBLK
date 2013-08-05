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

ActiveRecord::Schema.define(:version => 20130105104437) do

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

  create_table "custinsts", :force => true do |t|
    t.integer   "custords_id",                     :precision => 38, :scale => 0
    t.integer   "custrcvplcs_id",                  :precision => 38, :scale => 0
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

  add_index "custinsts", ["custords_id", "id"], :name => "custinsts_100_uk", :unique => true
  add_index "custinsts", ["duedate", "id"], :name => "custinsts_101_uk", :unique => true
  add_index "custinsts", ["sno", "lineno", "id"], :name => "custinsts_99_uk", :unique => true

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

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :precision => 38, :scale => 0, :default => 0
    t.integer  "attempts",   :precision => 38, :scale => 0, :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                                               :null => false
    t.datetime "updated_at",                                               :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

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
    t.integer   "id",                             :precision => 38, :scale => 0
    t.integer   "custins_id_pare",                :precision => 38, :scale => 0
    t.integer   "purords_id_pare",                :precision => 38, :scale => 0
    t.integer   "prcords_id_pare",                :precision => 38, :scale => 0
    t.integer   "purschs_id_pare",                :precision => 38, :scale => 0
    t.integer   "prcschs_id_pare",                :precision => 38, :scale => 0
    t.integer   "shpords_id",                     :precision => 38, :scale => 0
    t.timestamp "depdate",         :limit => 6
    t.timestamp "arrdate",         :limit => 6
    t.integer   "locas_id_from",                  :precision => 38, :scale => 0
    t.integer   "locas_id_to",                    :precision => 38, :scale => 0
    t.decimal   "qty",                            :precision => 16, :scale => 4
    t.integer   "carton",          :limit => 4,   :precision => 4,  :scale => 0
    t.decimal   "weight",                         :precision => 16, :scale => 4
    t.decimal   "volume",                         :precision => 16, :scale => 4
    t.string    "remark",          :limit => 200
    t.string    "update_ip",       :limit => 40
    t.timestamp "created_at",      :limit => 6
    t.timestamp "updated_at",      :limit => 6
  end

  create_table "sio_h1_custinsts", :force => true do |t|
    t.integer  "sio_user_code",                        :precision => 38, :scale => 0
    t.string   "sio_term_id",          :limit => 30
    t.string   "sio_session_id",       :limit => 256
    t.string   "sio_command_response", :limit => 1
    t.integer  "sio_session_counter",                  :precision => 38, :scale => 0
    t.string   "sio_classname",        :limit => 30
    t.string   "sio_viewname",         :limit => 30
    t.string   "sio_strsql",           :limit => 4000
    t.integer  "sio_totalcount",                       :precision => 38, :scale => 0
    t.integer  "sio_recordcount",                      :precision => 38, :scale => 0
    t.integer  "sio_start_record",                     :precision => 38, :scale => 0
    t.integer  "sio_end_record",                       :precision => 38, :scale => 0
    t.string   "sio_sord",             :limit => 256
    t.string   "sio_search",           :limit => 10
    t.string   "sio_sidx",             :limit => 256
    t.string   "person_code_chrg",     :limit => 10
    t.string   "cust_loca_code_cust",  :limit => 10
    t.string   "cust_loca_name_cust",  :limit => 100
    t.string   "itm_code",             :limit => 40
    t.string   "itm_name",             :limit => 100
    t.datetime "sio_add_time"
    t.datetime "sio_replay_time"
    t.string   "sio_result_f",         :limit => 1
    t.string   "sio_message_code",     :limit => 10
    t.string   "sio_message_contents", :limit => 256
    t.string   "sio_chk_done",         :limit => 1
  end

  add_index "sio_h1_custinsts", ["sio_user_code", "sio_session_id"], :name => "sio_h1_custinsts_uk1"

  create_table "sio_r_buttons", :force => true do |t|
    t.integer  "sio_user_code",                        :precision => 38, :scale => 0
    t.string   "sio_term_id",          :limit => 30
    t.string   "sio_session_id",       :limit => 256
    t.string   "sio_command_response", :limit => 1
    t.integer  "sio_session_counter",                  :precision => 38, :scale => 0
    t.string   "sio_classname",        :limit => 30
    t.string   "sio_viewname",         :limit => 30
    t.string   "sio_strsql",           :limit => 4000
    t.integer  "sio_totalcount",                       :precision => 38, :scale => 0
    t.integer  "sio_recordcount",                      :precision => 38, :scale => 0
    t.integer  "sio_start_record",                     :precision => 38, :scale => 0
    t.integer  "sio_end_record",                       :precision => 38, :scale => 0
    t.string   "sio_sord",             :limit => 256
    t.string   "sio_search",           :limit => 10
    t.string   "sio_sidx",             :limit => 256
    t.datetime "button_created_at"
    t.datetime "button_updated_at"
    t.string   "person_email_upd",     :limit => 30
    t.string   "button_update_ip",     :limit => 40
    t.decimal  "id_tbl"
    t.string   "screen_cdrflayout",    :limit => 10
    t.string   "screen_remark",        :limit => 200
    t.decimal  "screen_id"
    t.string   "screen_code",          :limit => 30
    t.string   "screen_viewname",      :limit => 30
    t.string   "screen_grpname",       :limit => 30
    t.string   "screen_strselect",     :limit => 4000
    t.string   "screen_strwhere",      :limit => 4000
    t.string   "screen_strgrouporder", :limit => 4000
    t.string   "button_icon",          :limit => 10
    t.string   "button_title",         :limit => 50
    t.string   "button_proc",          :limit => 20
    t.datetime "button_expiredate"
    t.string   "button_remark",        :limit => 200
    t.decimal  "person_id_upd"
    t.string   "person_code_upd",      :limit => 10
    t.string   "person_name_upd",      :limit => 100
    t.decimal  "usergroup_code_upd"
    t.string   "usergroup_name_upd",   :limit => 20
    t.datetime "sio_add_time"
    t.datetime "sio_replay_time"
    t.string   "sio_result_f",         :limit => 1
    t.string   "sio_message_code",     :limit => 10
    t.string   "sio_message_contents", :limit => 256
    t.string   "sio_chk_done",         :limit => 1
  end

  add_index "sio_r_buttons", ["sio_user_code", "sio_session_id"], :name => "sio_r_buttons_uk1"

  create_table "sio_r_childscreens", :force => true do |t|
    t.string   "user_code",        :limit => 10
    t.string   "term_id",          :limit => 30
    t.string   "session_id",       :limit => 256
    t.string   "command_response", :limit => 1
    t.integer  "session_counter",                  :precision => 38, :scale => 0
    t.string   "classname",        :limit => 30
    t.string   "sio_viewname",     :limit => 30
    t.string   "strsql",           :limit => 4000
    t.integer  "totalcount",                       :precision => 38, :scale => 0
    t.integer  "recordcount",                      :precision => 38, :scale => 0
    t.integer  "start_record",                     :precision => 38, :scale => 0
    t.integer  "end_record",                       :precision => 38, :scale => 0
    t.string   "sord",             :limit => 256
    t.string   "search",           :limit => 10
    t.string   "sidx",             :limit => 256
    t.datetime "add_time"
    t.datetime "replay_time"
    t.string   "result_f",         :limit => 1
    t.string   "message_code",     :limit => 10
    t.string   "message_contents", :limit => 256
    t.string   "chk_done",         :limit => 1
  end

  add_index "sio_r_childscreens", ["user_code", "session_id"], :name => "sio_r_childscreens_uk1"

  create_table "sio_r_chilscreens", :force => true do |t|
    t.integer  "sio_user_code",                             :precision => 38, :scale => 0
    t.string   "sio_term_id",               :limit => 30
    t.string   "sio_session_id",            :limit => 256
    t.string   "sio_command_response",      :limit => 1
    t.integer  "sio_session_counter",                       :precision => 38, :scale => 0
    t.string   "sio_classname",             :limit => 30
    t.string   "sio_viewname",              :limit => 30
    t.string   "sio_strsql",                :limit => 4000
    t.integer  "sio_totalcount",                            :precision => 38, :scale => 0
    t.integer  "sio_recordcount",                           :precision => 38, :scale => 0
    t.integer  "sio_start_record",                          :precision => 38, :scale => 0
    t.integer  "sio_end_record",                            :precision => 38, :scale => 0
    t.string   "sio_sord",                  :limit => 256
    t.string   "sio_search",                :limit => 10
    t.string   "sio_sidx",                  :limit => 256
    t.datetime "chilscreen_created_at"
    t.datetime "chilscreen_updated_at"
    t.string   "screen_grpname",            :limit => 30
    t.string   "screen_strselect",          :limit => 4000
    t.string   "screen_strwhere",           :limit => 4000
    t.string   "screen_strgrouporder",      :limit => 4000
    t.string   "screen_cdrflayout_chil",    :limit => 10
    t.string   "screen_remark_chil",        :limit => 200
    t.decimal  "screen_id_chil"
    t.string   "screen_code_chil",          :limit => 30
    t.string   "screen_viewname_chil",      :limit => 30
    t.string   "screen_grpname_chil",       :limit => 30
    t.string   "screen_strselect_chil",     :limit => 4000
    t.string   "screen_strwhere_chil",      :limit => 4000
    t.string   "screen_strgrouporder_chil", :limit => 4000
    t.datetime "chilscreen_expiredate"
    t.string   "chilscreen_remark",         :limit => 200
    t.decimal  "person_id_upd"
    t.string   "person_code_upd",           :limit => 10
    t.string   "person_name_upd",           :limit => 100
    t.decimal  "usergroup_code_upd"
    t.string   "usergroup_name_upd",        :limit => 20
    t.string   "person_email_upd",          :limit => 30
    t.string   "chilscreen_update_ip",      :limit => 40
    t.decimal  "id_tbl"
    t.string   "screen_cdrflayout",         :limit => 10
    t.string   "screen_remark",             :limit => 200
    t.decimal  "screen_id"
    t.string   "screen_code",               :limit => 30
    t.string   "screen_viewname",           :limit => 30
    t.datetime "sio_add_time"
    t.datetime "sio_replay_time"
    t.string   "sio_result_f",              :limit => 1
    t.string   "sio_message_code",          :limit => 10
    t.string   "sio_message_contents",      :limit => 256
    t.string   "sio_chk_done",              :limit => 1
  end

  add_index "sio_r_chilscreens", ["sio_user_code", "sio_session_id"], :name => "sio_r_chilscreens_uk1"

  create_table "sio_r_currencys", :force => true do |t|
    t.integer  "sio_user_code",                        :precision => 38, :scale => 0
    t.string   "sio_term_id",          :limit => 30
    t.string   "sio_session_id",       :limit => 256
    t.string   "sio_command_response", :limit => 1
    t.integer  "sio_session_counter",                  :precision => 38, :scale => 0
    t.string   "sio_classname",        :limit => 30
    t.string   "sio_viewname",         :limit => 30
    t.string   "sio_strsql",           :limit => 4000
    t.integer  "sio_totalcount",                       :precision => 38, :scale => 0
    t.integer  "sio_recordcount",                      :precision => 38, :scale => 0
    t.integer  "sio_start_record",                     :precision => 38, :scale => 0
    t.integer  "sio_end_record",                       :precision => 38, :scale => 0
    t.string   "sio_sord",             :limit => 256
    t.string   "sio_search",           :limit => 10
    t.string   "sio_sidx",             :limit => 256
    t.decimal  "id_tbl"
    t.string   "currency_code",        :limit => 3
    t.string   "currency_name",        :limit => 10
    t.string   "currency_remark",      :limit => 100
    t.decimal  "person_id_upd"
    t.string   "person_code_upd",      :limit => 10
    t.string   "person_name_upd",      :limit => 100
    t.decimal  "usergroup_code_upd"
    t.string   "usergroup_name_upd",   :limit => 20
    t.string   "person_email_upd",     :limit => 30
    t.datetime "currency_expiredate"
    t.string   "currency_update_ip",   :limit => 40
    t.datetime "currency_created_at"
    t.datetime "currency_updated_at"
    t.datetime "sio_add_time"
    t.datetime "sio_replay_time"
    t.string   "sio_result_f",         :limit => 1
    t.string   "sio_message_code",     :limit => 10
    t.string   "sio_message_contents", :limit => 256
    t.string   "sio_chk_done",         :limit => 1
  end

  add_index "sio_r_currencys", ["sio_user_code", "sio_session_id"], :name => "sio_r_currencys_uk1"

  create_table "sio_r_custinsts", :force => true do |t|
    t.integer   "sio_user_code",                           :precision => 38, :scale => 0
    t.string    "sio_term_id",             :limit => 30
    t.string    "sio_session_id",          :limit => 256
    t.string    "sio_command_response",    :limit => 1
    t.integer   "sio_session_counter",                     :precision => 38, :scale => 0
    t.string    "sio_classname",           :limit => 30
    t.string    "sio_viewname",            :limit => 30
    t.string    "sio_strsql",              :limit => 4000
    t.integer   "sio_totalcount",                          :precision => 38, :scale => 0
    t.integer   "sio_recordcount",                         :precision => 38, :scale => 0
    t.integer   "sio_start_record",                        :precision => 38, :scale => 0
    t.integer   "sio_end_record",                          :precision => 38, :scale => 0
    t.string    "sio_sord",                :limit => 256
    t.string    "sio_search",              :limit => 10
    t.string    "sio_sidx",                :limit => 256
    t.string    "loca_country_custrcvplc", :limit => 20
    t.string    "loca_prfct_custrcvplc",   :limit => 20
    t.string    "loca_addr1_custrcvplc",   :limit => 50
    t.string    "loca_addr2_custrcvplc",   :limit => 50
    t.string    "loca_tel_custrcvplc",     :limit => 20
    t.string    "loca_fax_custrcvplc",     :limit => 20
    t.string    "custrcvplc_remark",       :limit => 100
    t.string    "custinst_infomation",     :limit => 2000
    t.string    "custinst_remark",         :limit => 200
    t.decimal   "person_id_upd"
    t.string    "person_code_upd",         :limit => 10
    t.string    "person_name_upd",         :limit => 100
    t.decimal   "usergroup_code_upd"
    t.string    "usergroup_name_upd",      :limit => 20
    t.string    "person_email_upd",        :limit => 30
    t.string    "custinst_update_ip",      :limit => 40
    t.timestamp "custinst_created_at",     :limit => 6
    t.timestamp "custinst_updated_at",     :limit => 6
    t.decimal   "id_tbl"
    t.string    "currency_remark",         :limit => 100
    t.string    "cust_remark",             :limit => 100
    t.string    "cust_custtype",           :limit => 1
    t.string    "loca_mail_cust",          :limit => 20
    t.string    "loca_propucr_cust",       :limit => 1
    t.string    "loca_remark_cust",        :limit => 100
    t.string    "loca_code_cust",          :limit => 10
    t.string    "loca_name_cust",          :limit => 100
    t.string    "loca_abbr_cust",          :limit => 50
    t.string    "loca_zip_cust",           :limit => 10
    t.string    "loca_country_cust",       :limit => 20
    t.string    "loca_prfct_cust",         :limit => 20
    t.string    "loca_addr1_cust",         :limit => 50
    t.string    "loca_addr2_cust",         :limit => 50
    t.string    "loca_tel_cust",           :limit => 20
    t.string    "loca_fax_cust",           :limit => 20
    t.string    "unit_code",               :limit => 3
    t.string    "unit_name",               :limit => 10
    t.string    "unit_remark",             :limit => 100
    t.string    "itm_std",                 :limit => 100
    t.string    "itm_model",               :limit => 100
    t.string    "itm_material",            :limit => 100
    t.string    "itm_design",              :limit => 100
    t.decimal   "itm_weight",                              :precision => 10, :scale => 6
    t.decimal   "itm_length",                              :precision => 10, :scale => 6
    t.decimal   "itm_wide",                                :precision => 10, :scale => 6
    t.decimal   "itm_deth",                                :precision => 10, :scale => 6
    t.integer   "itm_packqty",             :limit => 10,   :precision => 10, :scale => 0
    t.decimal   "itm_minqty",                              :precision => 10, :scale => 6
    t.string    "itm_remark",              :limit => 100
    t.string    "itm_custtype",            :limit => 1
    t.string    "itm_code",                :limit => 40
    t.string    "itm_name",                :limit => 100
    t.timestamp "custord_duedate",         :limit => 6
    t.timestamp "custord_ordsdate",        :limit => 6
    t.decimal   "custord_qty"
    t.decimal   "custord_price"
    t.decimal   "custord_amt"
    t.string    "custord_sno",             :limit => 40
    t.decimal   "custord_lineno"
    t.string    "custord_infomation",      :limit => 2000
    t.string    "custord_remark",          :limit => 200
    t.decimal   "custord_id"
    t.string    "currency_code",           :limit => 3
    t.string    "currency_name",           :limit => 10
    t.decimal   "custrcvplc_id"
    t.string    "loca_mail_custrcvplc",    :limit => 20
    t.string    "loca_propucr_custrcvplc", :limit => 1
    t.string    "loca_remark_custrcvplc",  :limit => 100
    t.string    "loca_code_custrcvplc",    :limit => 10
    t.string    "loca_name_custrcvplc",    :limit => 100
    t.string    "loca_abbr_custrcvplc",    :limit => 50
    t.string    "loca_zip_custrcvplc",     :limit => 10
    t.timestamp "custinst_duedate",        :limit => 6
    t.timestamp "custinst_instdate",       :limit => 6
    t.decimal   "custinst_qty"
    t.decimal   "custinst_price"
    t.decimal   "custinst_amt"
    t.string    "custinst_sno",            :limit => 40
    t.decimal   "custinst_lineno"
    t.decimal   "person_id_chrg"
    t.string    "person_code_chrg",        :limit => 10
    t.string    "person_name_chrg",        :limit => 100
    t.decimal   "usergroup_code_chrg"
    t.string    "usergroup_name_chrg",     :limit => 20
    t.string    "person_email_chrg",       :limit => 30
    t.datetime  "sio_add_time"
    t.datetime  "sio_replay_time"
    t.string    "sio_result_f",            :limit => 1
    t.string    "sio_message_code",        :limit => 10
    t.string    "sio_message_contents",    :limit => 256
    t.string    "sio_chk_done",            :limit => 1
  end

  add_index "sio_r_custinsts", ["sio_user_code", "sio_session_id"], :name => "sio_r_custinsts_uk1"

  create_table "sio_r_custords", :force => true do |t|
    t.integer   "sio_user_code",                        :precision => 38, :scale => 0
    t.string    "sio_term_id",          :limit => 30
    t.string    "sio_session_id",       :limit => 256
    t.string    "sio_command_response", :limit => 1
    t.integer   "sio_session_counter",                  :precision => 38, :scale => 0
    t.string    "sio_classname",        :limit => 30
    t.string    "sio_viewname",         :limit => 30
    t.string    "sio_strsql",           :limit => 4000
    t.integer   "sio_totalcount",                       :precision => 38, :scale => 0
    t.integer   "sio_recordcount",                      :precision => 38, :scale => 0
    t.integer   "sio_start_record",                     :precision => 38, :scale => 0
    t.integer   "sio_end_record",                       :precision => 38, :scale => 0
    t.string    "sio_sord",             :limit => 256
    t.string    "sio_search",           :limit => 10
    t.string    "sio_sidx",             :limit => 256
    t.string    "custord_update_ip",    :limit => 40
    t.timestamp "custord_created_at",   :limit => 6
    t.timestamp "custord_updated_at",   :limit => 6
    t.string    "currency_remark",      :limit => 100
    t.string    "cust_remark",          :limit => 100
    t.string    "cust_custtype",        :limit => 1
    t.decimal   "cust_id"
    t.string    "loca_mail_cust",       :limit => 20
    t.string    "loca_propucr_cust",    :limit => 1
    t.string    "loca_remark_cust",     :limit => 100
    t.string    "loca_code_cust",       :limit => 10
    t.string    "loca_name_cust",       :limit => 100
    t.string    "loca_abbr_cust",       :limit => 50
    t.string    "loca_zip_cust",        :limit => 10
    t.string    "loca_country_cust",    :limit => 20
    t.string    "loca_prfct_cust",      :limit => 20
    t.string    "loca_addr1_cust",      :limit => 50
    t.string    "loca_addr2_cust",      :limit => 50
    t.string    "loca_tel_cust",        :limit => 20
    t.string    "loca_fax_cust",        :limit => 20
    t.string    "unit_code",            :limit => 3
    t.string    "unit_name",            :limit => 10
    t.string    "unit_remark",          :limit => 100
    t.string    "itm_std",              :limit => 100
    t.string    "itm_model",            :limit => 100
    t.string    "itm_material",         :limit => 100
    t.string    "itm_design",           :limit => 100
    t.decimal   "itm_weight",                           :precision => 10, :scale => 6
    t.decimal   "itm_length",                           :precision => 10, :scale => 6
    t.decimal   "itm_wide",                             :precision => 10, :scale => 6
    t.decimal   "itm_deth",                             :precision => 10, :scale => 6
    t.integer   "itm_packqty",          :limit => 10,   :precision => 10, :scale => 0
    t.decimal   "itm_minqty",                           :precision => 10, :scale => 6
    t.string    "itm_remark",           :limit => 100
    t.string    "itm_custtype",         :limit => 1
    t.decimal   "itm_id"
    t.string    "itm_code",             :limit => 40
    t.string    "itm_name",             :limit => 100
    t.decimal   "person_id_chrg"
    t.string    "person_code_chrg",     :limit => 10
    t.string    "person_name_chrg",     :limit => 100
    t.decimal   "usergroup_code_chrg"
    t.string    "usergroup_name_chrg",  :limit => 20
    t.string    "person_email_chrg",    :limit => 30
    t.timestamp "custord_duedate",      :limit => 6
    t.timestamp "custord_ordsdate",     :limit => 6
    t.decimal   "custord_qty"
    t.decimal   "custord_price"
    t.decimal   "custord_amt"
    t.string    "custord_sno",          :limit => 40
    t.decimal   "custord_lineno"
    t.string    "custord_infomation",   :limit => 2000
    t.string    "custord_remark",       :limit => 200
    t.datetime  "custord_expiredate"
    t.decimal   "person_id_upd"
    t.string    "person_code_upd",      :limit => 10
    t.string    "person_name_upd",      :limit => 100
    t.decimal   "usergroup_code_upd"
    t.string    "usergroup_name_upd",   :limit => 20
    t.string    "person_email_upd",     :limit => 30
    t.decimal   "id_tbl"
    t.string    "currency_code",        :limit => 3
    t.string    "currency_name",        :limit => 10
    t.datetime  "sio_add_time"
    t.datetime  "sio_replay_time"
    t.string    "sio_result_f",         :limit => 1
    t.string    "sio_message_code",     :limit => 10
    t.string    "sio_message_contents", :limit => 256
    t.string    "sio_chk_done",         :limit => 1
  end

  add_index "sio_r_custords", ["sio_user_code", "sio_session_id"], :name => "sio_r_custords_uk1"

  create_table "sio_r_custrcvplcs", :force => true do |t|
    t.integer  "sio_user_code",                                  :precision => 38, :scale => 0
    t.string   "sio_term_id",                    :limit => 30
    t.string   "sio_session_id",                 :limit => 256
    t.string   "sio_command_response",           :limit => 1
    t.integer  "sio_session_counter",                            :precision => 38, :scale => 0
    t.string   "sio_classname",                  :limit => 30
    t.string   "sio_viewname",                   :limit => 30
    t.string   "sio_strsql",                     :limit => 4000
    t.integer  "sio_totalcount",                                 :precision => 38, :scale => 0
    t.integer  "sio_recordcount",                                :precision => 38, :scale => 0
    t.integer  "sio_start_record",                               :precision => 38, :scale => 0
    t.integer  "sio_end_record",                                 :precision => 38, :scale => 0
    t.string   "sio_sord",                       :limit => 256
    t.string   "sio_search",                     :limit => 10
    t.string   "sio_sidx",                       :limit => 256
    t.datetime "custrcvplc_updated_at"
    t.string   "loca_remark_custrcvplc",         :limit => 100
    t.decimal  "loca_id_custrcvplc"
    t.string   "loca_code_custrcvplc",           :limit => 10
    t.string   "loca_name_custrcvplc",           :limit => 100
    t.string   "loca_abbr_custrcvplc",           :limit => 50
    t.string   "loca_zip_custrcvplc",            :limit => 10
    t.string   "loca_country_custrcvplc",        :limit => 20
    t.string   "loca_prfct_custrcvplc",          :limit => 20
    t.string   "loca_addr1_custrcvplc",          :limit => 50
    t.string   "loca_addr2_custrcvplc",          :limit => 50
    t.string   "loca_tel_custrcvplc",            :limit => 20
    t.string   "loca_mail_custrcvplc",           :limit => 20
    t.string   "custrcvplc_personnameofoutside", :limit => 100
    t.decimal  "person_id_chrg"
    t.string   "person_code_chrg",               :limit => 10
    t.string   "person_name_chrg",               :limit => 100
    t.decimal  "usergroup_code_chrg"
    t.string   "usergroup_name_chrg",            :limit => 20
    t.string   "person_email_chrg",              :limit => 30
    t.string   "custrcvplc_remark",              :limit => 100
    t.datetime "custrcvplc_expiredate"
    t.decimal  "person_id_upd"
    t.string   "person_code_upd",                :limit => 10
    t.string   "person_name_upd",                :limit => 100
    t.decimal  "usergroup_code_upd"
    t.string   "usergroup_name_upd",             :limit => 20
    t.string   "person_email_upd",               :limit => 30
    t.string   "custrcvplc_update_ip",           :limit => 40
    t.datetime "custrcvplc_created_at"
    t.decimal  "id_tbl"
    t.string   "loca_fax_custrcvplc",            :limit => 20
    t.string   "loca_propucr_custrcvplc",        :limit => 1
    t.datetime "sio_add_time"
    t.datetime "sio_replay_time"
    t.string   "sio_result_f",                   :limit => 1
    t.string   "sio_message_code",               :limit => 10
    t.string   "sio_message_contents",           :limit => 256
    t.string   "sio_chk_done",                   :limit => 1
  end

  add_index "sio_r_custrcvplcs", ["sio_user_code", "sio_session_id"], :name => "sio_r_custrcvplcs_uk1"

  create_table "sio_r_custs", :force => true do |t|
    t.integer  "sio_user_code",                         :precision => 38, :scale => 0
    t.string   "sio_term_id",           :limit => 30
    t.string   "sio_session_id",        :limit => 256
    t.string   "sio_command_response",  :limit => 1
    t.integer  "sio_session_counter",                   :precision => 38, :scale => 0
    t.string   "sio_classname",         :limit => 30
    t.string   "sio_viewname",          :limit => 30
    t.string   "sio_strsql",            :limit => 4000
    t.integer  "sio_totalcount",                        :precision => 38, :scale => 0
    t.integer  "sio_recordcount",                       :precision => 38, :scale => 0
    t.integer  "sio_start_record",                      :precision => 38, :scale => 0
    t.integer  "sio_end_record",                        :precision => 38, :scale => 0
    t.string   "sio_sord",              :limit => 256
    t.string   "sio_search",            :limit => 10
    t.string   "sio_sidx",              :limit => 256
    t.string   "currency_code",         :limit => 3
    t.string   "currency_name",         :limit => 10
    t.string   "currency_remark",       :limit => 100
    t.string   "cust_remark",           :limit => 100
    t.string   "cust_custtype",         :limit => 1
    t.datetime "cust_expiredate"
    t.decimal  "person_id_upd"
    t.string   "person_code_upd",       :limit => 10
    t.string   "person_name_upd",       :limit => 100
    t.decimal  "usergroup_code_upd"
    t.string   "usergroup_name_upd",    :limit => 20
    t.string   "person_email_upd",      :limit => 30
    t.string   "cust_update_ip",        :limit => 40
    t.datetime "cust_created_at"
    t.datetime "cust_updated_at"
    t.decimal  "id_tbl"
    t.string   "loca_fax_cust",         :limit => 20
    t.string   "loca_propucr_cust",     :limit => 1
    t.string   "loca_remark_cust",      :limit => 100
    t.decimal  "loca_id_cust"
    t.string   "loca_code_cust",        :limit => 10
    t.string   "loca_name_cust",        :limit => 100
    t.string   "loca_abbr_cust",        :limit => 50
    t.string   "loca_zip_cust",         :limit => 10
    t.string   "loca_country_cust",     :limit => 20
    t.string   "loca_prfct_cust",       :limit => 20
    t.string   "loca_addr1_cust",       :limit => 50
    t.string   "loca_addr2_cust",       :limit => 50
    t.string   "loca_tel_cust",         :limit => 20
    t.string   "loca_mail_cust",        :limit => 20
    t.string   "cust_personnameofcust", :limit => 30
    t.decimal  "person_id_chrg"
    t.string   "person_code_chrg",      :limit => 10
    t.string   "person_name_chrg",      :limit => 100
    t.decimal  "usergroup_code_chrg"
    t.string   "usergroup_name_chrg",   :limit => 20
    t.string   "person_email_chrg",     :limit => 30
    t.decimal  "currency_id"
    t.datetime "sio_add_time"
    t.datetime "sio_replay_time"
    t.string   "sio_result_f",          :limit => 1
    t.string   "sio_message_code",      :limit => 10
    t.string   "sio_message_contents",  :limit => 256
    t.string   "sio_chk_done",          :limit => 1
  end

  add_index "sio_r_custs", ["sio_user_code", "sio_session_id"], :name => "sio_r_custs_uk1"

  create_table "sio_r_detailfields", :force => true do |t|
    t.integer  "sio_user_code",                             :precision => 38, :scale => 0
    t.string   "sio_term_id",               :limit => 30
    t.string   "sio_session_id",            :limit => 256
    t.string   "sio_command_response",      :limit => 1
    t.integer  "sio_session_counter",                       :precision => 38, :scale => 0
    t.string   "sio_classname",             :limit => 30
    t.string   "sio_viewname",              :limit => 30
    t.string   "sio_strsql",                :limit => 4000
    t.integer  "sio_totalcount",                            :precision => 38, :scale => 0
    t.integer  "sio_recordcount",                           :precision => 38, :scale => 0
    t.integer  "sio_start_record",                          :precision => 38, :scale => 0
    t.integer  "sio_end_record",                            :precision => 38, :scale => 0
    t.string   "sio_sord",                  :limit => 256
    t.string   "sio_search",                :limit => 10
    t.string   "sio_sidx",                  :limit => 256
    t.decimal  "id_tbl"
    t.string   "screen_cdrflayout",         :limit => 10
    t.string   "screen_remark",             :limit => 200
    t.decimal  "screen_id"
    t.string   "screen_code",               :limit => 30
    t.string   "screen_viewname",           :limit => 30
    t.string   "screen_grpname",            :limit => 30
    t.string   "screen_strselect",          :limit => 4000
    t.string   "screen_strwhere",           :limit => 4000
    t.string   "screen_strgrouporder",      :limit => 4000
    t.decimal  "detailfield_selection"
    t.decimal  "detailfield_hideflg"
    t.decimal  "detailfield_seqno"
    t.decimal  "detailfield_searchform"
    t.decimal  "detailfield_paragraph"
    t.string   "detailfield_code",          :limit => 30
    t.decimal  "detailfield_width"
    t.string   "detailfield_type",          :limit => 106
    t.decimal  "detailfield_length"
    t.decimal  "detailfield_dataprecision"
    t.decimal  "detailfield_datascale"
    t.string   "detailfield_defaultvalue",  :limit => 40
    t.decimal  "detailfield_indisp"
    t.decimal  "detailfield_subindisp"
    t.decimal  "detailfield_editable"
    t.string   "detailfield_editablehide",  :limit => 12
    t.string   "detailfield_listoptions",   :limit => 40
    t.string   "detailfield_tblkey",        :limit => 30
    t.string   "detailfield_crtfield",      :limit => 100
    t.datetime "detailfield_expiredate"
    t.string   "detailfield_remark",        :limit => 200
    t.decimal  "person_id_upd"
    t.string   "person_code_upd",           :limit => 10
    t.string   "person_name_upd",           :limit => 100
    t.decimal  "usergroup_code_upd"
    t.string   "usergroup_name_upd",        :limit => 20
    t.string   "person_email_upd",          :limit => 30
    t.string   "detailfield_update_ip",     :limit => 40
    t.datetime "detailfield_created_at"
    t.datetime "detailfield_updated_at"
    t.decimal  "detailfield_rowpos"
    t.decimal  "detailfield_colpos"
    t.decimal  "detailfield_inputsize"
    t.decimal  "detailfield_maxlength"
    t.datetime "sio_add_time"
    t.datetime "sio_replay_time"
    t.string   "sio_result_f",              :limit => 1
    t.string   "sio_message_code",          :limit => 10
    t.string   "sio_message_contents",      :limit => 256
    t.string   "sio_chk_done",              :limit => 1
  end

  add_index "sio_r_detailfields", ["sio_user_code", "sio_session_id"], :name => "sio_r_detailfields_uk1"

  create_table "sio_r_fobjects", :force => true do |t|
    t.integer  "sio_user_code",                             :precision => 38, :scale => 0
    t.string   "sio_term_id",               :limit => 30
    t.string   "sio_session_id",            :limit => 256
    t.string   "sio_command_response",      :limit => 1
    t.integer  "sio_session_counter",                       :precision => 38, :scale => 0
    t.string   "sio_classname",             :limit => 30
    t.string   "sio_viewname",              :limit => 30
    t.string   "sio_strsql",                :limit => 4000
    t.integer  "sio_totalcount",                            :precision => 38, :scale => 0
    t.integer  "sio_recordcount",                           :precision => 38, :scale => 0
    t.integer  "sio_start_record",                          :precision => 38, :scale => 0
    t.integer  "sio_end_record",                            :precision => 38, :scale => 0
    t.string   "sio_sord",                  :limit => 256
    t.string   "sio_search",                :limit => 10
    t.string   "sio_sidx",                  :limit => 256
    t.decimal  "id_tbl"
    t.datetime "pobject_update_at"
    t.decimal  "pobject_id"
    t.string   "pobject_objecttype",        :limit => 20
    t.string   "pobject_code",              :limit => 30
    t.string   "pobject_contens",           :limit => 200
    t.string   "pobject_remark",            :limit => 200
    t.text     "pobject_rubycode"
    t.decimal  "fobject_fieldlength"
    t.decimal  "fobject_datapresion"
    t.decimal  "fobject_datascale"
    t.decimal  "person_id_upd"
    t.string   "person_code_upd",           :limit => 10
    t.string   "person_name_upd",           :limit => 100
    t.decimal  "usergroup_code_upd"
    t.string   "usergroup_name_upd",        :limit => 20
    t.string   "fobject_fielddenomination", :limit => 40
    t.string   "fobject_contens",           :limit => 200
    t.string   "fobject_remark",            :limit => 200
    t.string   "fobject_update_ip",         :limit => 40
    t.datetime "fobject_created_at"
    t.datetime "fobject_expiredate"
    t.datetime "fobject_update_at"
    t.datetime "sio_add_time"
    t.datetime "sio_replay_time"
    t.string   "sio_result_f",              :limit => 1
    t.string   "sio_message_code",          :limit => 10
    t.string   "sio_message_contents",      :limit => 256
    t.string   "sio_chk_done",              :limit => 1
  end

  add_index "sio_r_fobjects", ["sio_user_code", "sio_session_id"], :name => "sio_r_fobjects_uk1"

  create_table "sio_r_fobjgrps", :force => true do |t|
    t.integer  "sio_user_code",                             :precision => 38, :scale => 0
    t.string   "sio_term_id",               :limit => 30
    t.string   "sio_session_id",            :limit => 256
    t.string   "sio_command_response",      :limit => 1
    t.integer  "sio_session_counter",                       :precision => 38, :scale => 0
    t.string   "sio_classname",             :limit => 30
    t.string   "sio_viewname",              :limit => 30
    t.string   "sio_strsql",                :limit => 4000
    t.integer  "sio_totalcount",                            :precision => 38, :scale => 0
    t.integer  "sio_recordcount",                           :precision => 38, :scale => 0
    t.integer  "sio_start_record",                          :precision => 38, :scale => 0
    t.integer  "sio_end_record",                            :precision => 38, :scale => 0
    t.string   "sio_sord",                  :limit => 256
    t.string   "sio_search",                :limit => 10
    t.string   "sio_sidx",                  :limit => 256
    t.decimal  "id_tbl"
    t.decimal  "fobject_id"
    t.datetime "pobject_update_at"
    t.string   "pobject_objecttype",        :limit => 20
    t.string   "pobject_code",              :limit => 30
    t.string   "pobject_contens",           :limit => 200
    t.string   "pobject_remark",            :limit => 200
    t.text     "pobject_rubycode"
    t.decimal  "fobject_fieldlength"
    t.decimal  "fobject_datapresion"
    t.decimal  "fobject_datascale"
    t.string   "fobject_fielddenomination", :limit => 40
    t.string   "fobject_contens",           :limit => 200
    t.string   "fobject_remark",            :limit => 200
    t.datetime "fobject_update_at"
    t.string   "fobjgrp_name",              :limit => 30
    t.decimal  "usergroup_id"
    t.decimal  "usergroup_code"
    t.string   "usergroup_name",            :limit => 20
    t.string   "usergroup_remark",          :limit => 100
    t.string   "fobjgrp_remark",            :limit => 200
    t.decimal  "person_id_upd"
    t.string   "person_code_upd",           :limit => 10
    t.string   "person_name_upd",           :limit => 100
    t.decimal  "usergroup_code_upd"
    t.string   "usergroup_name_upd",        :limit => 20
    t.string   "fobjgrp_update_ip",         :limit => 40
    t.datetime "fobjgrp_created_at"
    t.datetime "fobjgrp_expiredate"
    t.datetime "fobjgrp_update_at"
    t.datetime "sio_add_time"
    t.datetime "sio_replay_time"
    t.string   "sio_result_f",              :limit => 1
    t.string   "sio_message_code",          :limit => 10
    t.string   "sio_message_contents",      :limit => 256
    t.string   "sio_chk_done",              :limit => 1
  end

  add_index "sio_r_fobjgrps", ["sio_user_code", "sio_session_id"], :name => "sio_r_fobjgrps_uk1"

  create_table "sio_r_invps", :force => true do |t|
    t.integer  "sio_user_code",                        :precision => 38, :scale => 0
    t.string   "sio_term_id",          :limit => 30
    t.string   "sio_session_id",       :limit => 256
    t.string   "sio_command_response", :limit => 1
    t.integer  "sio_session_counter",                  :precision => 38, :scale => 0
    t.string   "sio_classname",        :limit => 30
    t.string   "sio_viewname",         :limit => 30
    t.string   "sio_strsql",           :limit => 4000
    t.integer  "sio_totalcount",                       :precision => 38, :scale => 0
    t.integer  "sio_recordcount",                      :precision => 38, :scale => 0
    t.integer  "sio_start_record",                     :precision => 38, :scale => 0
    t.integer  "sio_end_record",                       :precision => 38, :scale => 0
    t.string   "sio_sord",             :limit => 256
    t.string   "sio_search",           :limit => 10
    t.string   "sio_sidx",             :limit => 256
    t.decimal  "id_tbl"
    t.string   "loca_fax_invp",        :limit => 20
    t.string   "loca_mail_invp",       :limit => 20
    t.string   "loca_propucr_invp",    :limit => 1
    t.string   "loca_remark_invp",     :limit => 100
    t.decimal  "loca_id_invp"
    t.string   "loca_code_invp",       :limit => 10
    t.string   "loca_name_invp",       :limit => 100
    t.string   "loca_abbr_invp",       :limit => 50
    t.string   "loca_zip_invp",        :limit => 10
    t.string   "loca_country_invp",    :limit => 20
    t.string   "loca_prfct_invp",      :limit => 20
    t.string   "loca_addr1_invp",      :limit => 50
    t.string   "loca_addr2_invp",      :limit => 50
    t.string   "loca_tel_invp",        :limit => 20
    t.decimal  "person_id_owner"
    t.string   "person_code_owner",    :limit => 10
    t.string   "person_name_owner",    :limit => 100
    t.decimal  "usergroup_code_owner"
    t.string   "usergroup_name_owner", :limit => 20
    t.integer  "invp_invntmaxqty",     :limit => 10,   :precision => 10, :scale => 0
    t.string   "invp_remark",          :limit => 100
    t.datetime "invp_expiredate"
    t.decimal  "person_id_upd"
    t.string   "person_code_upd",      :limit => 10
    t.string   "person_name_upd",      :limit => 100
    t.decimal  "usergroup_code_upd"
    t.string   "usergroup_name_upd",   :limit => 20
    t.string   "invp_update_ip",       :limit => 40
    t.datetime "invp_created_at"
    t.datetime "invp_updated_at"
    t.datetime "sio_add_time"
    t.datetime "sio_replay_time"
    t.string   "sio_result_f",         :limit => 1
    t.string   "sio_message_code",     :limit => 10
    t.string   "sio_message_contents", :limit => 256
    t.string   "sio_chk_done",         :limit => 1
  end

  add_index "sio_r_invps", ["sio_user_code", "sio_session_id"], :name => "sio_r_invps_uk1"

  create_table "sio_r_itms", :force => true do |t|
    t.integer  "sio_user_code",                        :precision => 38, :scale => 0
    t.string   "sio_term_id",          :limit => 30
    t.string   "sio_session_id",       :limit => 256
    t.string   "sio_command_response", :limit => 1
    t.integer  "sio_session_counter",                  :precision => 38, :scale => 0
    t.string   "sio_classname",        :limit => 30
    t.string   "sio_viewname",         :limit => 30
    t.string   "sio_strsql",           :limit => 4000
    t.integer  "sio_totalcount",                       :precision => 38, :scale => 0
    t.integer  "sio_recordcount",                      :precision => 38, :scale => 0
    t.integer  "sio_start_record",                     :precision => 38, :scale => 0
    t.integer  "sio_end_record",                       :precision => 38, :scale => 0
    t.string   "sio_sord",             :limit => 256
    t.string   "sio_search",           :limit => 10
    t.string   "sio_sidx",             :limit => 256
    t.string   "unit_code",            :limit => 3
    t.string   "unit_name",            :limit => 10
    t.string   "unit_remark",          :limit => 100
    t.string   "itm_std",              :limit => 100
    t.string   "itm_model",            :limit => 100
    t.string   "itm_material",         :limit => 100
    t.string   "itm_design",           :limit => 100
    t.decimal  "itm_weight",                           :precision => 10, :scale => 6
    t.decimal  "itm_length",                           :precision => 10, :scale => 6
    t.decimal  "itm_wide",                             :precision => 10, :scale => 6
    t.decimal  "itm_deth",                             :precision => 10, :scale => 6
    t.integer  "itm_packqty",          :limit => 10,   :precision => 10, :scale => 0
    t.decimal  "itm_minqty",                           :precision => 10, :scale => 6
    t.string   "itm_remark",           :limit => 100
    t.string   "itm_custtype",         :limit => 1
    t.datetime "itm_expiredate"
    t.decimal  "person_id_upd"
    t.string   "person_code_upd",      :limit => 10
    t.string   "person_name_upd",      :limit => 100
    t.decimal  "usergroup_code_upd"
    t.string   "usergroup_name_upd",   :limit => 20
    t.string   "person_email_upd",     :limit => 30
    t.string   "itm_update_ip",        :limit => 40
    t.datetime "itm_created_at"
    t.datetime "itm_updated_at"
    t.decimal  "id_tbl"
    t.string   "itm_code",             :limit => 40
    t.string   "itm_name",             :limit => 100
    t.decimal  "unit_id"
    t.datetime "sio_add_time"
    t.datetime "sio_replay_time"
    t.string   "sio_result_f",         :limit => 1
    t.string   "sio_message_code",     :limit => 10
    t.string   "sio_message_contents", :limit => 256
    t.string   "sio_chk_done",         :limit => 1
  end

  add_index "sio_r_itms", ["sio_user_code", "sio_session_id"], :name => "sio_r_itms_uk1"

  create_table "sio_r_locas", :force => true do |t|
    t.integer  "sio_user_code",                        :precision => 38, :scale => 0
    t.string   "sio_term_id",          :limit => 30
    t.string   "sio_session_id",       :limit => 256
    t.string   "sio_command_response", :limit => 1
    t.integer  "sio_session_counter",                  :precision => 38, :scale => 0
    t.string   "sio_classname",        :limit => 30
    t.string   "sio_viewname",         :limit => 30
    t.string   "sio_strsql",           :limit => 4000
    t.integer  "sio_totalcount",                       :precision => 38, :scale => 0
    t.integer  "sio_recordcount",                      :precision => 38, :scale => 0
    t.integer  "sio_start_record",                     :precision => 38, :scale => 0
    t.integer  "sio_end_record",                       :precision => 38, :scale => 0
    t.string   "sio_sord",             :limit => 256
    t.string   "sio_search",           :limit => 10
    t.string   "sio_sidx",             :limit => 256
    t.string   "loca_fax",             :limit => 20
    t.string   "loca_propucr",         :limit => 1
    t.string   "loca_remark",          :limit => 100
    t.datetime "loca_expiredate"
    t.decimal  "person_id_upd"
    t.string   "person_code_upd",      :limit => 10
    t.string   "person_name_upd",      :limit => 100
    t.decimal  "usergroup_code_upd"
    t.string   "usergroup_name_upd",   :limit => 20
    t.string   "person_email_upd",     :limit => 30
    t.string   "loca_update_ip",       :limit => 40
    t.datetime "loca_created_at"
    t.datetime "loca_updated_at"
    t.decimal  "id_tbl"
    t.string   "loca_code",            :limit => 10
    t.string   "loca_name",            :limit => 100
    t.string   "loca_abbr",            :limit => 50
    t.string   "loca_zip",             :limit => 10
    t.string   "loca_country",         :limit => 20
    t.string   "loca_prfct",           :limit => 20
    t.string   "loca_addr1",           :limit => 50
    t.string   "loca_addr2",           :limit => 50
    t.string   "loca_tel",             :limit => 20
    t.string   "loca_mail",            :limit => 20
    t.datetime "sio_add_time"
    t.datetime "sio_replay_time"
    t.string   "sio_result_f",         :limit => 1
    t.string   "sio_message_code",     :limit => 10
    t.string   "sio_message_contents", :limit => 256
    t.string   "sio_chk_done",         :limit => 1
  end

  add_index "sio_r_locas", ["sio_user_code", "sio_session_id"], :name => "sio_r_locas_uk1"

  create_table "sio_r_persons", :force => true do |t|
    t.integer  "sio_user_code",                        :precision => 38, :scale => 0
    t.string   "sio_term_id",          :limit => 30
    t.string   "sio_session_id",       :limit => 256
    t.string   "sio_command_response", :limit => 1
    t.integer  "sio_session_counter",                  :precision => 38, :scale => 0
    t.string   "sio_classname",        :limit => 30
    t.string   "sio_viewname",         :limit => 30
    t.string   "sio_strsql",           :limit => 4000
    t.integer  "sio_totalcount",                       :precision => 38, :scale => 0
    t.integer  "sio_recordcount",                      :precision => 38, :scale => 0
    t.integer  "sio_start_record",                     :precision => 38, :scale => 0
    t.integer  "sio_end_record",                       :precision => 38, :scale => 0
    t.string   "sio_sord",             :limit => 256
    t.string   "sio_search",           :limit => 10
    t.string   "sio_sidx",             :limit => 256
    t.decimal  "id_tbl"
    t.string   "person_code",          :limit => 10
    t.string   "person_name",          :limit => 100
    t.decimal  "usergroup_id"
    t.decimal  "usergroup_code"
    t.string   "usergroup_name",       :limit => 20
    t.datetime "sio_add_time"
    t.datetime "sio_replay_time"
    t.string   "sio_result_f",         :limit => 1
    t.string   "sio_message_code",     :limit => 10
    t.string   "sio_message_contents", :limit => 256
    t.string   "sio_chk_done",         :limit => 1
  end

  add_index "sio_r_persons", ["sio_user_code", "sio_session_id"], :name => "sio_r_persons_uk1"

  create_table "sio_r_pobject", :force => true do |t|
    t.integer  "sio_user_code",                        :precision => 38, :scale => 0
    t.string   "sio_term_id",          :limit => 30
    t.string   "sio_session_id",       :limit => 256
    t.string   "sio_command_response", :limit => 1
    t.integer  "sio_session_counter",                  :precision => 38, :scale => 0
    t.string   "sio_classname",        :limit => 30
    t.string   "sio_viewname",         :limit => 30
    t.string   "sio_strsql",           :limit => 4000
    t.integer  "sio_totalcount",                       :precision => 38, :scale => 0
    t.integer  "sio_recordcount",                      :precision => 38, :scale => 0
    t.integer  "sio_start_record",                     :precision => 38, :scale => 0
    t.integer  "sio_end_record",                       :precision => 38, :scale => 0
    t.string   "sio_sord",             :limit => 256
    t.string   "sio_search",           :limit => 10
    t.string   "sio_sidx",             :limit => 256
    t.datetime "sio_add_time"
    t.datetime "sio_replay_time"
    t.string   "sio_result_f",         :limit => 1
    t.string   "sio_message_code",     :limit => 10
    t.string   "sio_message_contents", :limit => 256
    t.string   "sio_chk_done",         :limit => 1
  end

  add_index "sio_r_pobject", ["sio_user_code", "sio_session_id"], :name => "sio_r_pobject_uk1"

  create_table "sio_r_pobjects", :force => true do |t|
    t.integer  "sio_user_code",                        :precision => 38, :scale => 0
    t.string   "sio_term_id",          :limit => 30
    t.string   "sio_session_id",       :limit => 256
    t.string   "sio_command_response", :limit => 1
    t.integer  "sio_session_counter",                  :precision => 38, :scale => 0
    t.string   "sio_classname",        :limit => 30
    t.string   "sio_viewname",         :limit => 30
    t.string   "sio_strsql",           :limit => 4000
    t.integer  "sio_totalcount",                       :precision => 38, :scale => 0
    t.integer  "sio_recordcount",                      :precision => 38, :scale => 0
    t.integer  "sio_start_record",                     :precision => 38, :scale => 0
    t.integer  "sio_end_record",                       :precision => 38, :scale => 0
    t.string   "sio_sord",             :limit => 256
    t.string   "sio_search",           :limit => 10
    t.string   "sio_sidx",             :limit => 256
    t.datetime "pobject_updated_at"
    t.decimal  "id_tbl"
    t.string   "pobject_objecttype",   :limit => 20
    t.string   "pobject_code",         :limit => 30
    t.string   "pobject_contens",      :limit => 200
    t.string   "pobject_remark",       :limit => 200
    t.text     "pobject_rubycode"
    t.decimal  "person_id_upd"
    t.string   "person_code_upd",      :limit => 10
    t.string   "person_name_upd",      :limit => 100
    t.decimal  "usergroup_code_upd"
    t.string   "usergroup_name_upd",   :limit => 20
    t.string   "person_email_upd",     :limit => 30
    t.string   "pobject_update_ip",    :limit => 40
    t.datetime "pobject_created_at"
    t.datetime "pobject_expiredate"
    t.datetime "sio_add_time"
    t.datetime "sio_replay_time"
    t.string   "sio_result_f",         :limit => 1
    t.string   "sio_message_code",     :limit => 10
    t.string   "sio_message_contents", :limit => 256
    t.string   "sio_chk_done",         :limit => 1
  end

  add_index "sio_r_pobjects", ["sio_user_code", "sio_session_id"], :name => "sio_r_pobjects_uk1"

  create_table "sio_r_pobjgrps", :force => true do |t|
    t.integer  "sio_user_code",                        :precision => 38, :scale => 0
    t.string   "sio_term_id",          :limit => 30
    t.string   "sio_session_id",       :limit => 256
    t.string   "sio_command_response", :limit => 1
    t.integer  "sio_session_counter",                  :precision => 38, :scale => 0
    t.string   "sio_classname",        :limit => 30
    t.string   "sio_viewname",         :limit => 30
    t.string   "sio_strsql",           :limit => 4000
    t.integer  "sio_totalcount",                       :precision => 38, :scale => 0
    t.integer  "sio_recordcount",                      :precision => 38, :scale => 0
    t.integer  "sio_start_record",                     :precision => 38, :scale => 0
    t.integer  "sio_end_record",                       :precision => 38, :scale => 0
    t.string   "sio_sord",             :limit => 256
    t.string   "sio_search",           :limit => 10
    t.string   "sio_sidx",             :limit => 256
    t.datetime "pobjgrp_updated_at"
    t.decimal  "usergroup_code_upd"
    t.string   "usergroup_name_upd",   :limit => 20
    t.string   "person_email_upd",     :limit => 30
    t.string   "pobjgrp_update_ip",    :limit => 40
    t.datetime "pobjgrp_created_at"
    t.datetime "pobjgrp_expiredate"
    t.decimal  "id_tbl"
    t.decimal  "pobject_id"
    t.string   "pobject_objecttype",   :limit => 20
    t.string   "pobject_code",         :limit => 30
    t.string   "pobject_contens",      :limit => 200
    t.string   "pobject_remark",       :limit => 200
    t.text     "pobject_rubycode"
    t.decimal  "usergroup_id"
    t.decimal  "usergroup_code"
    t.string   "usergroup_name",       :limit => 20
    t.string   "usergroup_remark",     :limit => 100
    t.string   "pobjgrp_name",         :limit => 30
    t.string   "pobjgrp_remark",       :limit => 200
    t.decimal  "person_id_upd"
    t.string   "person_code_upd",      :limit => 10
    t.string   "person_name_upd",      :limit => 100
    t.datetime "sio_add_time"
    t.datetime "sio_replay_time"
    t.string   "sio_result_f",         :limit => 1
    t.string   "sio_message_code",     :limit => 10
    t.string   "sio_message_contents", :limit => 256
    t.string   "sio_chk_done",         :limit => 1
  end

  add_index "sio_r_pobjgrps", ["sio_user_code", "sio_session_id"], :name => "sio_r_pobjgrps_uk1"

  create_table "sio_r_pprojects", :force => true do |t|
    t.integer  "sio_user_code",                        :precision => 38, :scale => 0
    t.string   "sio_term_id",          :limit => 30
    t.string   "sio_session_id",       :limit => 256
    t.string   "sio_command_response", :limit => 1
    t.integer  "sio_session_counter",                  :precision => 38, :scale => 0
    t.string   "sio_classname",        :limit => 30
    t.string   "sio_viewname",         :limit => 30
    t.string   "sio_strsql",           :limit => 4000
    t.integer  "sio_totalcount",                       :precision => 38, :scale => 0
    t.integer  "sio_recordcount",                      :precision => 38, :scale => 0
    t.integer  "sio_start_record",                     :precision => 38, :scale => 0
    t.integer  "sio_end_record",                       :precision => 38, :scale => 0
    t.string   "sio_sord",             :limit => 256
    t.string   "sio_search",           :limit => 10
    t.string   "sio_sidx",             :limit => 256
    t.datetime "sio_add_time"
    t.datetime "sio_replay_time"
    t.string   "sio_result_f",         :limit => 1
    t.string   "sio_message_code",     :limit => 10
    t.string   "sio_message_contents", :limit => 256
    t.string   "sio_chk_done",         :limit => 1
  end

  add_index "sio_r_pprojects", ["sio_user_code", "sio_session_id"], :name => "sio_r_pprojects_uk1"

  create_table "sio_r_screens", :force => true do |t|
    t.integer  "sio_user_code",                        :precision => 38, :scale => 0
    t.string   "sio_term_id",          :limit => 30
    t.string   "sio_session_id",       :limit => 256
    t.string   "sio_command_response", :limit => 1
    t.integer  "sio_session_counter",                  :precision => 38, :scale => 0
    t.string   "sio_classname",        :limit => 30
    t.string   "sio_viewname",         :limit => 30
    t.string   "sio_strsql",           :limit => 4000
    t.integer  "sio_totalcount",                       :precision => 38, :scale => 0
    t.integer  "sio_recordcount",                      :precision => 38, :scale => 0
    t.integer  "sio_start_record",                     :precision => 38, :scale => 0
    t.integer  "sio_end_record",                       :precision => 38, :scale => 0
    t.string   "sio_sord",             :limit => 256
    t.string   "sio_search",           :limit => 10
    t.string   "sio_sidx",             :limit => 256
    t.string   "screen_cdrflayout",    :limit => 10
    t.datetime "screen_expiredate"
    t.string   "screen_remark",        :limit => 200
    t.decimal  "person_id_upd"
    t.string   "person_code_upd",      :limit => 10
    t.string   "person_name_upd",      :limit => 100
    t.decimal  "usergroup_code_upd"
    t.string   "usergroup_name_upd",   :limit => 20
    t.string   "person_email_upd",     :limit => 30
    t.string   "screen_update_ip",     :limit => 40
    t.datetime "screen_created_at"
    t.datetime "screen_updated_at"
    t.decimal  "id_tbl"
    t.string   "screen_code",          :limit => 30
    t.string   "screen_viewname",      :limit => 30
    t.string   "screen_grpname",       :limit => 30
    t.string   "screen_strselect",     :limit => 4000
    t.string   "screen_strwhere",      :limit => 4000
    t.string   "screen_strgrouporder", :limit => 4000
    t.datetime "sio_add_time"
    t.datetime "sio_replay_time"
    t.string   "sio_result_f",         :limit => 1
    t.string   "sio_message_code",     :limit => 10
    t.string   "sio_message_contents", :limit => 256
    t.string   "sio_chk_done",         :limit => 1
  end

  add_index "sio_r_screens", ["sio_user_code", "sio_session_id"], :name => "sio_r_screens_uk1"

  create_table "sio_r_units", :force => true do |t|
    t.integer  "sio_user_code",                        :precision => 38, :scale => 0
    t.string   "sio_term_id",          :limit => 30
    t.string   "sio_session_id",       :limit => 256
    t.string   "sio_command_response", :limit => 1
    t.integer  "sio_session_counter",                  :precision => 38, :scale => 0
    t.string   "sio_classname",        :limit => 30
    t.string   "sio_viewname",         :limit => 30
    t.string   "sio_strsql",           :limit => 4000
    t.integer  "sio_totalcount",                       :precision => 38, :scale => 0
    t.integer  "sio_recordcount",                      :precision => 38, :scale => 0
    t.integer  "sio_start_record",                     :precision => 38, :scale => 0
    t.integer  "sio_end_record",                       :precision => 38, :scale => 0
    t.string   "sio_sord",             :limit => 256
    t.string   "sio_search",           :limit => 10
    t.string   "sio_sidx",             :limit => 256
    t.string   "person_code_upd",      :limit => 10
    t.string   "person_name_upd",      :limit => 100
    t.decimal  "usergroup_code_upd"
    t.string   "usergroup_name_upd",   :limit => 20
    t.string   "person_email_upd",     :limit => 30
    t.datetime "unit_expiredate"
    t.string   "unit_update_ip",       :limit => 40
    t.datetime "unit_created_at"
    t.datetime "unit_updated_at"
    t.decimal  "id_tbl"
    t.string   "unit_code",            :limit => 3
    t.string   "unit_name",            :limit => 10
    t.string   "unit_remark",          :limit => 100
    t.decimal  "person_id_upd"
    t.datetime "sio_add_time"
    t.datetime "sio_replay_time"
    t.string   "sio_result_f",         :limit => 1
    t.string   "sio_message_code",     :limit => 10
    t.string   "sio_message_contents", :limit => 256
    t.string   "sio_chk_done",         :limit => 1
  end

  add_index "sio_r_units", ["sio_user_code", "sio_session_id"], :name => "sio_r_units_uk1"

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
