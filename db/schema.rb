# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_08_29_144558) do
  create_table "classroom_modules", force: :cascade do |t|
    t.integer "classroom_program_id", null: false
    t.integer "content_module_id", null: false
    t.datetime "created_at", null: false
    t.date "publish_on"
    t.datetime "updated_at", null: false
    t.index ["classroom_program_id", "content_module_id"], name: "index_classroom_modules_on_classroom_program_and_content_module", unique: true
    t.index ["classroom_program_id"], name: "index_classroom_modules_on_classroom_program_id"
    t.index ["content_module_id"], name: "index_classroom_modules_on_content_module_id"
  end

  create_table "classroom_programs", force: :cascade do |t|
    t.integer "classroom_id", null: false
    t.datetime "created_at", null: false
    t.string "level", null: false
    t.integer "program_id", null: false
    t.datetime "updated_at", null: false
    t.index ["classroom_id", "program_id"], name: "index_classroom_programs_on_classroom_id_and_program_id", unique: true
    t.index ["classroom_id"], name: "index_classroom_programs_on_classroom_id"
    t.index ["program_id"], name: "index_classroom_programs_on_program_id"
  end

  create_table "classrooms", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.integer "school_id", null: false
    t.integer "teacher_id"
    t.datetime "updated_at", null: false
    t.string "uuid", null: false
    t.index ["school_id"], name: "index_classrooms_on_school_id"
    t.index ["teacher_id"], name: "index_classrooms_on_teacher_id"
    t.index ["uuid"], name: "index_classrooms_on_uuid", unique: true
  end

  create_table "content_modules", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "level", null: false
    t.string "name", null: false
    t.integer "position"
    t.integer "program_id", null: false
    t.datetime "updated_at", null: false
    t.index ["program_id"], name: "index_content_modules_on_program_id"
  end

  create_table "links", force: :cascade do |t|
    t.integer "content_module_id", null: false
    t.datetime "created_at", null: false
    t.string "link_type", null: false
    t.integer "position"
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.string "url", null: false
    t.index ["content_module_id"], name: "index_links_on_content_module_id"
  end

  create_table "programs", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "schools", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "student_sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "student_id", null: false
    t.datetime "updated_at", null: false
    t.index ["student_id"], name: "index_student_sessions_on_student_id"
  end

  create_table "students", force: :cascade do |t|
    t.integer "classroom_id", null: false
    t.datetime "created_at", null: false
    t.string "email"
    t.string "first_name", null: false
    t.string "gender"
    t.integer "grade_level", null: false
    t.string "last_name", null: false
    t.integer "school_id", null: false
    t.datetime "updated_at", null: false
    t.index ["classroom_id"], name: "index_students_on_classroom_id"
    t.index ["school_id"], name: "index_students_on_school_id"
  end

  create_table "teachers", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.string "name"
    t.integer "school_id", null: false
    t.datetime "updated_at", null: false
    t.index ["school_id"], name: "index_teachers_on_school_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email_address", null: false
    t.string "name", null: false
    t.string "password_digest", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  add_foreign_key "classroom_modules", "classroom_programs"
  add_foreign_key "classroom_modules", "content_modules"
  add_foreign_key "classroom_programs", "classrooms"
  add_foreign_key "classroom_programs", "programs"
  add_foreign_key "classrooms", "schools"
  add_foreign_key "classrooms", "teachers"
  add_foreign_key "content_modules", "programs"
  add_foreign_key "links", "content_modules"
  add_foreign_key "sessions", "users"
  add_foreign_key "student_sessions", "students"
  add_foreign_key "students", "classrooms"
  add_foreign_key "students", "schools"
  add_foreign_key "teachers", "schools"
end
