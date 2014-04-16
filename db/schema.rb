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

ActiveRecord::Schema.define(:version => 20131107142627) do

  create_table "courses", :force => true do |t|
    t.integer  "year"
    t.string   "period"
    t.boolean  "active"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
    t.integer  "review_round"
    t.integer  "week"
    t.integer  "state"
    t.boolean  "mandatory_reviews"
    t.string   "name"
    t.integer  "week_feedback_max_points"
    t.boolean  "email_student"
    t.boolean  "email_instructor"
  end

  create_table "feedback_comments", :force => true do |t|
    t.text     "text"
    t.integer  "user_id"
    t.integer  "week_feedback_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "peer_reviews", :force => true do |t|
    t.string   "notes"
    t.boolean  "done"
    t.integer  "reviewer_id"
    t.integer  "reviewed_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "round"
  end

  create_table "registrations", :force => true do |t|
    t.string   "topic"
    t.string   "repository"
    t.integer  "user_id"
    t.integer  "course_id"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.boolean  "participate_review1"
    t.boolean  "participate_review2"
    t.boolean  "active"
    t.decimal  "review1"
    t.decimal  "review2"
  end

  create_table "users", :force => true do |t|
    t.string   "forename"
    t.string   "surename"
    t.string   "student_number"
    t.string   "email"
    t.boolean  "admin"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.string   "password_digest"
    t.boolean  "participate_review2"
    t.boolean  "hidden"
  end

  create_table "week_feedbacks", :force => true do |t|
    t.integer  "week"
    t.text     "text"
    t.integer  "registration_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.text     "hidden_text"
    t.decimal  "points"
    t.integer  "giver_id"
  end

end
