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

ActiveRecord::Schema.define(version: 2020_08_20_025949) do

  create_table "assignments", force: :cascade do |t|
    t.string "title"
    t.date "due_date"
    t.float "weighting"
    t.integer "max_points"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "course_id"
  end

  create_table "course_members", force: :cascade do |t|
    t.string "role"
    t.integer "marker_id"
    t.integer "course_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_course_members_on_course_id"
    t.index ["marker_id"], name: "index_course_members_on_marker_id"
  end

  create_table "courses", primary_key: "course_id", force: :cascade do |t|
    t.date "eff_date"
    t.string "short_title"
    t.string "long_title"
    t.text "descr"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "subject"
  end

  create_table "markers", force: :cascade do |t|
    t.string "uni_id"
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "submissions", force: :cascade do |t|
    t.integer "assignment_id"
    t.integer "grade"
    t.date "submitted_date"
    t.text "feedback"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assignment_id"], name: "index_submissions_on_assignment_id"
  end

end
