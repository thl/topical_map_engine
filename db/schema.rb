# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090731042553) do

  create_table "authors_descriptions", :id => false, :force => true do |t|
    t.integer "author_id",      :null => false
    t.integer "description_id", :null => false
  end

  add_index "authors_descriptions", ["author_id", "description_id"], :name => "index_authors_descriptions_on_author_id_and_description_id", :unique => true

  create_table "authors_translated_sources", :id => false, :force => true do |t|
    t.integer "author_id",            :null => false
    t.integer "translated_source_id", :null => false
  end

  add_index "authors_translated_sources", ["author_id", "translated_source_id"], :name => "authors_translated_sources_index", :unique => true

  create_table "authors_translated_titles", :id => false, :force => true do |t|
    t.integer "author_id",           :null => false
    t.integer "translated_title_id", :null => false
  end

  add_index "authors_translated_titles", ["author_id", "translated_title_id"], :name => "authors_translated_titles_index", :unique => true

  create_table "categories", :force => true do |t|
    t.string   "title",                         :null => false
    t.integer  "parent_id"
    t.integer  "creator_id",                    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "published",  :default => false, :null => false
    t.boolean  "cumulative", :default => true,  :null => false
  end

  create_table "categories_curators", :id => false, :force => true do |t|
    t.integer "category_id", :null => false
    t.integer "curator_id",  :null => false
  end

  add_index "categories_curators", ["category_id", "curator_id"], :name => "index_categories_curators_on_category_id_and_curator_id", :unique => true

  create_table "descriptions", :force => true do |t|
    t.integer  "category_id",                    :null => false
    t.text     "content",                        :null => false
    t.integer  "language_id",                    :null => false
    t.boolean  "is_main",     :default => false, :null => false
    t.integer  "creator_id",                     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
  end

  create_table "globalize_countries", :force => true do |t|
    t.string "code",                   :limit => 2
    t.string "english_name"
    t.string "date_format"
    t.string "currency_format"
    t.string "currency_code",          :limit => 3
    t.string "thousands_sep",          :limit => 2
    t.string "decimal_sep",            :limit => 2
    t.string "currency_decimal_sep",   :limit => 2
    t.string "number_grouping_scheme"
  end

  add_index "globalize_countries", ["code"], :name => "index_globalize_countries_on_code"

  create_table "globalize_languages", :force => true do |t|
    t.string  "iso_639_1",             :limit => 2
    t.string  "iso_639_2",             :limit => 3
    t.string  "iso_639_3",             :limit => 3
    t.string  "rfc_3066"
    t.string  "english_name"
    t.string  "english_name_locale"
    t.string  "english_name_modifier"
    t.string  "native_name"
    t.string  "native_name_locale"
    t.string  "native_name_modifier"
    t.boolean "macro_language"
    t.string  "direction"
    t.string  "pluralization"
    t.string  "scope",                 :limit => 1
  end

  add_index "globalize_languages", ["iso_639_1"], :name => "index_globalize_languages_on_iso_639_1"
  add_index "globalize_languages", ["iso_639_2"], :name => "index_globalize_languages_on_iso_639_2"
  add_index "globalize_languages", ["iso_639_3"], :name => "index_globalize_languages_on_iso_639_3"
  add_index "globalize_languages", ["rfc_3066"], :name => "index_globalize_languages_on_rfc_3066"

  create_table "globalize_translations", :force => true do |t|
    t.string  "type"
    t.string  "tr_key"
    t.string  "table_name"
    t.integer "item_id"
    t.string  "facet"
    t.boolean "built_in",            :default => false
    t.integer "language_id"
    t.integer "pluralization_index"
    t.text    "text"
    t.string  "namespace"
  end

  add_index "globalize_translations", ["table_name", "item_id", "language_id"], :name => "globalize_translations_table_name_and_item_and_language"
  add_index "globalize_translations", ["tr_key", "language_id"], :name => "index_globalize_translations_on_tr_key_and_language_id"

  create_table "languages", :force => true do |t|
    t.string  "title",                   :limit => 100,                    :null => false
    t.string  "code",                    :limit => 3,                      :null => false
    t.string  "locale",                  :limit => 6,                      :null => false
    t.integer "languages",                              :default => 0,     :null => false
    t.integer "unicode_codepoint_start"
    t.integer "unicode_codepoint_end"
    t.boolean "use_for_interface",                      :default => false, :null => false
  end

  create_table "open_id_authentication_associations", :force => true do |t|
    t.integer "issued"
    t.integer "lifetime"
    t.string  "handle"
    t.string  "assoc_type"
    t.binary  "server_url"
    t.binary  "secret"
  end

  create_table "open_id_authentication_nonces", :force => true do |t|
    t.integer "timestamp",  :null => false
    t.string  "server_url", :null => false
    t.string  "salt",       :null => false
  end

  create_table "people", :force => true do |t|
    t.string   "fullname",   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "permissions", :force => true do |t|
    t.string   "title",       :limit => 60, :null => false
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "permissions", ["title"], :name => "index_permissions_on_title", :unique => true

  create_table "permissions_roles", :id => false, :force => true do |t|
    t.integer "permission_id", :null => false
    t.integer "role_id",       :null => false
  end

  add_index "permissions_roles", ["permission_id", "role_id"], :name => "index_permissions_roles_on_permission_id_and_role_id", :unique => true

  create_table "roles", :force => true do |t|
    t.string   "title",       :limit => 20, :null => false
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["title"], :name => "index_roles_on_title", :unique => true

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "role_id", :null => false
    t.integer "user_id", :null => false
  end

  add_index "roles_users", ["role_id", "user_id"], :name => "index_roles_users_on_role_id_and_user_id", :unique => true

  create_table "sources", :force => true do |t|
    t.integer  "resource_id"
    t.string   "resource_type"
    t.integer  "mms_id"
    t.integer  "volume_number"
    t.integer  "start_page"
    t.integer  "start_line"
    t.integer  "end_page"
    t.integer  "end_line"
    t.text     "passage"
    t.integer  "language_id",   :null => false
    t.text     "note"
    t.integer  "creator_id",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "translated_sources", :force => true do |t|
    t.text     "title",       :null => false
    t.integer  "language_id", :null => false
    t.integer  "source_id",   :null => false
    t.integer  "creator_id",  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "translated_titles", :force => true do |t|
    t.string   "title",       :null => false
    t.integer  "language_id", :null => false
    t.integer  "category_id", :null => false
    t.integer  "creator_id",  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login",                                   :null => false
    t.string   "email",                                   :null => false
    t.integer  "person_id"
    t.string   "crypted_password",          :limit => 40, :null => false
    t.string   "salt",                      :limit => 40
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "identity_url"
  end

end
