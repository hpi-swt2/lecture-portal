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

ActiveRecord::Schema.define(version: 2020_01_29_225856) do

  create_table "answers", force: :cascade do |t|
    t.integer "student_id"
    t.integer "option_id"
    t.integer "poll_id"
    t.index ["option_id"], name: "index_answers_on_option_id"
    t.index ["poll_id"], name: "index_answers_on_poll_id"
    t.index ["student_id"], name: "index_answers_on_student_id"
  end

  create_table "courses", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "status", default: "open"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "creator_id"
    t.integer "lecture_id"
    t.index ["creator_id"], name: "index_courses_on_creator_id"
    t.index ["lecture_id"], name: "index_courses_on_lecture_id"
  end

  create_table "courses_users", id: false, force: :cascade do |t|
    t.integer "course_id", null: false
    t.integer "user_id", null: false
    t.index ["course_id", "user_id"], name: "index_courses_users_on_course_id_and_user_id"
    t.index ["user_id", "course_id"], name: "index_courses_users_on_user_id_and_course_id"
  end

  create_table "feedbacks", force: :cascade do |t|
    t.text "content"
    t.integer "lecture_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["lecture_id"], name: "index_feedbacks_on_lecture_id"
    t.index ["user_id"], name: "index_feedbacks_on_user_id"
  end

  create_table "lecture_comprehension_stamps", id: false, force: :cascade do |t|
    t.integer "lecture_id", null: false
    t.integer "user_id", null: false
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lecture_id", "user_id"], name: "index_lecture_comprehension_stamps_on_lecture_id_and_user_id"
    t.index ["user_id", "lecture_id"], name: "index_lecture_comprehension_stamps_on_user_id_and_lecture_id"
  end

  create_table "lectures", force: :cascade do |t|
    t.string "name"
    t.string "enrollment_key"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "questions_enabled", default: true
    t.boolean "polls_enabled", default: true
    t.string "status", default: "created"
    t.integer "lecturer_id"
    t.integer "course_id"
    t.date "date"
    t.time "start_time"
    t.time "end_time"
    t.boolean "feedback_enabled", default: true
    t.index ["course_id"], name: "index_lectures_on_course_id"
    t.index ["lecturer_id"], name: "index_lectures_on_lecturer_id"
  end

  create_table "lectures_users", id: false, force: :cascade do |t|
    t.integer "lecture_id", null: false
    t.integer "user_id", null: false
    t.index ["lecture_id", "user_id"], name: "index_lectures_users_on_lecture_id_and_user_id"
    t.index ["user_id", "lecture_id"], name: "index_lectures_users_on_user_id_and_lecture_id"
  end

  create_table "poll_options", force: :cascade do |t|
    t.text "description"
    t.integer "poll_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "votes", default: 0, null: false
    t.decimal "index"
    t.index ["poll_id"], name: "index_poll_options_on_poll_id"
  end

  create_table "polls", force: :cascade do |t|
    t.string "title"
    t.boolean "is_multiselect"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "lecture_id"
    t.boolean "is_active", default: true, null: false
    t.index ["lecture_id"], name: "index_polls_on_lecture_id"
  end

  create_table "questions", force: :cascade do |t|
    t.string "content"
    t.integer "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "resolved", default: false, null: false
    t.integer "lecture_id"
    t.index ["author_id"], name: "index_questions_on_author_id"
    t.index ["lecture_id"], name: "index_questions_on_lecture_id"
  end

  create_table "questions_users", id: false, force: :cascade do |t|
    t.integer "question_id", null: false
    t.integer "user_id", null: false
    t.index ["question_id", "user_id"], name: "index_questions_users_on_question_id_and_user_id"
    t.index ["user_id", "question_id"], name: "index_questions_users_on_user_id_and_question_id"
  end

  create_table "uploaded_files", force: :cascade do |t|
    t.string "content_type"
    t.string "filename"
    t.binary "data"
    t.string "allowsUpload_type"
    t.integer "allowsUpload_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "author_id"
    t.boolean "isLink", default: false
    t.index ["allowsUpload_type", "allowsUpload_id"], name: "index_uploaded_files_on_allowsUpload_type_and_allowsUpload_id"
    t.index ["author_id"], name: "index_uploaded_files_on_author_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_student", default: false, null: false
    t.integer "feedback_id"
    t.string "hash_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["feedback_id"], name: "index_users_on_feedback_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
