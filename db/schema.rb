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

ActiveRecord::Schema.define(version: 2020_10_19_022913) do

  create_table "assignments", force: :cascade do |t|
    t.string "title"
    t.date "due_date"
    t.float "weighting"
    t.integer "max_points"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "course_id"
  end

  create_table "comments", force: :cascade do |t|
    t.integer "submission_id"
    t.integer "marker_id", null: false
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["marker_id"], name: "index_comments_on_marker_id"
    t.index ["submission_id"], name: "index_comments_on_submission_id"
  end

  create_table "course_members", id: false, force: :cascade do |t|
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

  create_table "courses_students", id: false, force: :cascade do |t|
    t.integer "course_id"
    t.integer "student_id"
    t.index ["course_id"], name: "index_courses_students_on_course_id"
    t.index ["student_id"], name: "index_courses_students_on_student_id"
  end

  create_table "markers", primary_key: "marker_id", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "students", primary_key: "student_id", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "submissions", force: :cascade do |t|
    t.integer "assignment_id"
    t.date "submitted_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "student_id"
    t.date "marked_date"
    t.float "grade"
    t.index ["assignment_id"], name: "index_submissions_on_assignment_id"
  end

end
