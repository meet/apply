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

ActiveRecord::Schema.define(:version => 20120222120000) do

  create_table "businesses", :force => true do |t|
    t.string   "first_name",       :null => false
    t.string   "last_name",        :null => false
    t.string   "email",            :null => false
    t.string   "major"
    t.date     "graduation_year"
    t.text     "why_meet"
    t.text     "experience"
    t.text     "teamwork"
    t.text     "limitations"
    t.text     "anything_else"
    t.string   "resume_file_name"
    t.string   "how_hear"
    t.datetime "created_at"
  end

  create_table "calls", :id => false, :force => true do |t|
    t.column :id, 'varchar(32) primary key not null'
    t.boolean "open",             :default => false
    t.boolean "reviewable",       :default => false
    t.string  "title"
    t.text    "description"
    t.date    "deadline"
    t.string  "identity_columns"
  end

  create_table "fellows", :force => true do |t|
    t.string   "first_name",       :null => false
    t.string   "last_name",        :null => false
    t.string   "email",            :null => false
    t.string   "major"
    t.string   "affiliation"
    t.text     "why_fellow"
    t.text     "challenges"
    t.text     "role"
    t.text     "foreign"
    t.text     "mission"
    t.string   "resume_file_name"
    t.string   "how_hear"
    t.datetime "created_at"
  end

  create_table "instructor_reviews", :force => true do |t|
    t.string   "app_reviewer_id", :null => false
    t.integer  "app_id",          :null => false
    t.integer  "enthusiasm"
    t.integer  "programming"
    t.integer  "teaching"
    t.integer  "teamwork"
    t.integer  "overall"
    t.boolean  "y1"
    t.boolean  "y2"
    t.boolean  "y3"
    t.boolean  "interview"
    t.text     "comment"
    t.datetime "created_at"
  end

  add_index "instructor_reviews", ["app_reviewer_id", "app_id"], :name => "index_instructor_reviews_on_app_reviewer_id_and_app_id", :unique => true

  create_table "instructors", :force => true do |t|
    t.string   "first_name",       :null => false
    t.string   "last_name",        :null => false
    t.string   "email",            :null => false
    t.string   "major"
    t.string   "status"
    t.date     "graduation_year"
    t.text     "why_meet"
    t.text     "programming"
    t.text     "teaching"
    t.text     "teamwork"
    t.text     "anything_else"
    t.string   "resume_file_name"
    t.string   "how_hear"
    t.datetime "created_at"
  end

  create_table "students", :force => true do |t|
    t.string   "_student_first_name",  :null => false
    t.string   "_student_last_name",   :null => false
    t.integer  "_student_id_number",   :null => false
    t.string   "_student_gender",      :null => false
    t.date     "_student_birthday"
    t.string   "_student_city"
    t.string   "_student_school"
    t.string   "_student_address"
    t.string   "_student_home_phone"
    t.string   "_student_cell_phone"
    t.string   "_student_email",       :null => false
    t.string   "_parent_full_name",    :null => false
    t.string   "_parent_work_phone"
    t.string   "_parent_cell_phone"
    t.string   "_parent_email"
    t.boolean  "_permission_to_apply"
    t.datetime "created_at"
  end

end
