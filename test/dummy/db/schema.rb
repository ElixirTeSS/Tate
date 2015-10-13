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

ActiveRecord::Schema.define(version: 20151013161807) do

  create_table "books", force: :cascade do |t|
    t.text     "name"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "tate_annotation_attributes", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tate_annotation_attributes", ["name"], name: "index_tate_annotation_attributes_on_name"

  create_table "tate_annotation_value_seeds", force: :cascade do |t|
    t.integer  "attribute_id",                                       null: false
    t.string   "old_value"
    t.string   "annotation_attributes",                              null: false
    t.string   "identifier",                                         null: false
    t.string   "string",                                             null: false
    t.string   "value_type",            limit: 50, default: "FIXME", null: false
    t.integer  "value_id",                         default: 0,       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tate_annotation_value_seeds", ["attribute_id"], name: "index_tate_annotation_value_seeds_on_attribute_id"

  create_table "tate_annotation_versions", force: :cascade do |t|
    t.integer  "annotation_id",                                       null: false
    t.integer  "version",                                             null: false
    t.integer  "version_creator_id"
    t.string   "source_type",                                         null: false
    t.integer  "source_id",                                           null: false
    t.string   "annotatable_type",   limit: 50,                       null: false
    t.integer  "annotatable_id",                                      null: false
    t.integer  "attribute_id",                                        null: false
    t.string   "old_value"
    t.string   "value_type",         limit: 50, default: "TextValue", null: false
    t.integer  "value_id",                      default: 0,           null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tate_annotation_versions", ["annotation_id"], name: "index_tate_annotation_versions_on_annotation_id"

  create_table "tate_annotations", force: :cascade do |t|
    t.string   "source_type",                                         null: false
    t.integer  "source_id",                                           null: false
    t.string   "annotatable_type",   limit: 50,                       null: false
    t.integer  "annotatable_id",                                      null: false
    t.integer  "attribute_id",                                        null: false
    t.string   "old_value"
    t.string   "value_type",         limit: 50, default: "TextValue", null: false
    t.integer  "value_id",                      default: 0,           null: false
    t.integer  "version",                                             null: false
    t.integer  "version_creator_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tate_annotations", ["annotatable_type", "annotatable_id"], name: "index_tate_annotations_on_annotatable_type_and_annotatable_id"
  add_index "tate_annotations", ["attribute_id"], name: "index_tate_annotations_on_attribute_id"
  add_index "tate_annotations", ["source_type", "source_id"], name: "index_tate_annotations_on_source_type_and_source_id"
  add_index "tate_annotations", ["value_type", "value_id"], name: "index_tate_annotations_on_value_type_and_value_id"

  create_table "tate_number_value_versions", force: :cascade do |t|
    t.integer  "number_value_id",    null: false
    t.integer  "version",            null: false
    t.integer  "version_creator_id"
    t.integer  "number",             null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tate_number_value_versions", ["number_value_id"], name: "index_tate_number_value_versions_on_number_value_id"

  create_table "tate_number_values", force: :cascade do |t|
    t.integer  "version",            null: false
    t.integer  "version_creator_id"
    t.integer  "number",             null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tate_text_value_versions", force: :cascade do |t|
    t.integer  "text_value_id",                       null: false
    t.integer  "version",                             null: false
    t.integer  "version_creator_id"
    t.text     "text",               limit: 16777214, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tate_text_value_versions", ["text_value_id"], name: "index_tate_text_value_versions_on_text_value_id"

  create_table "tate_text_values", force: :cascade do |t|
    t.integer  "version",                             null: false
    t.integer  "version_creator_id"
    t.text     "text",               limit: 16777214, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
