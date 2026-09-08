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

ActiveRecord::Schema[8.1].define(version: 2026_09_08_025955) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "events", force: :cascade do |t|
    t.integer "action"
    t.string "actor"
    t.datetime "created_at", null: false
    t.integer "event_type", null: false
    t.string "github_delivery_id", null: false
    t.datetime "occurred_at"
    t.jsonb "payload"
    t.string "repo_full_name", null: false
    t.datetime "updated_at", null: false
    t.index ["github_delivery_id"], name: "index_events_on_github_delivery_id", unique: true
  end

  create_table "repositories", force: :cascade do |t|
    t.string "avatar_url"
    t.datetime "created_at", null: false
    t.string "default_branch"
    t.string "description"
    t.string "full_name", null: false
    t.string "html_url"
    t.string "language"
    t.integer "stargazers_count", default: 0
    t.datetime "updated_at", null: false
    t.index ["full_name"], name: "index_repositories_on_full_name", unique: true
  end
end
