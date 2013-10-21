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

ActiveRecord::Schema.define(version: 20131017043033) do

  create_table "training_answer", primary_key: "answer_id", force: true do |t|
    t.integer  "question_id",    limit: 8
    t.integer  "answer_no"
    t.text     "answer_content"
    t.string   "answer_file",    limit: 512
    t.integer  "answer_correct"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "active_flag"
  end

  create_table "training_answer_sheet", primary_key: "answer_sheet_id", force: true do |t|
    t.integer  "user_id"
    t.integer  "exam_question_id"
    t.integer  "examination_id",   limit: 8
    t.integer  "subject_id"
    t.integer  "no"
    t.integer  "exam_result"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "active_flag"
  end

  create_table "training_answer_sheet_detail", primary_key: "answer_sheet_detail_id", force: true do |t|
    t.integer  "answer_sheet_id", limit: 8
    t.integer  "question_id",     limit: 8
    t.integer  "answer_id",       limit: 8
    t.integer  "no"
    t.text     "answer_content"
    t.string   "answer_file",     limit: 512
    t.integer  "answer_correct"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "active_flag"
  end

  create_table "training_conclusion", primary_key: "conclusion_id", force: true do |t|
    t.string   "conclusion_name", limit: 128
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "active_flag"
  end

  create_table "training_exam_question", primary_key: "exam_question_id", force: true do |t|
    t.string   "subject_id",     limit: 45
    t.integer  "level_id"
    t.integer  "number_correct"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "active_flag"
    t.integer  "exam_time"
  end

  create_table "training_exam_question_detail", primary_key: "exam_question_detail_id", force: true do |t|
    t.integer  "exam_question_id"
    t.integer  "subject_id"
    t.integer  "question_group_id"
    t.integer  "number_question"
    t.integer  "no"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "active_flag"
  end

  create_table "training_examination", primary_key: "examination_id", force: true do |t|
    t.integer  "user_id"
    t.integer  "conclusion_id"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "active_flag"
  end

  create_table "training_examination_detail", primary_key: "examination_detail_id", force: true do |t|
    t.integer  "examination_id",   limit: 8
    t.integer  "exam_question_id"
    t.integer  "exam_result"
    t.time     "exam_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "active_flag"
  end

  create_table "training_level", primary_key: "level_id", force: true do |t|
    t.string   "level_name",  limit: 128
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "active_flag"
  end

  create_table "training_question", primary_key: "question_id", force: true do |t|
    t.integer  "subject_id"
    t.integer  "question_group_id"
    t.text     "question_content"
    t.string   "question_file",     limit: 512
    t.integer  "answer_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "active_flag"
    t.string   "description",       limit: 128
  end

  create_table "training_question_group", primary_key: "question_group_id", force: true do |t|
    t.string   "question_group_name", limit: 128
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "active_flag"
  end

  create_table "training_subject", primary_key: "subject_id", force: true do |t|
    t.string   "subject_name", limit: 256
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "active_flag"
  end

  create_table "training_subject_question_group", primary_key: "subject_question_group_id", force: true do |t|
    t.integer  "subject_id"
    t.integer  "question_group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "active_flag"
  end

  create_table "training_user", primary_key: "user_id", force: true do |t|
    t.string   "full_name",       limit: 256, null: false
    t.string   "email",           limit: 256, null: false
    t.string   "password_digest", limit: 64
    t.string   "remember_token",  limit: 256
    t.integer  "user_admin"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "active_flag"
  end

  add_index "training_user", ["email"], name: "index_users_on_email", length: {"email"=>255}, using: :btree
  add_index "training_user", ["remember_token"], name: "index_users_on_remember_token", using: :btree

end
