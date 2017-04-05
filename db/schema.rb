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

ActiveRecord::Schema.define(version: 20170207060058) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.string   "author_type"
    t.integer  "author_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree
  end

  create_table "activities", force: :cascade do |t|
    t.string   "trackable_type"
    t.integer  "trackable_id"
    t.string   "owner_type"
    t.integer  "owner_id"
    t.string   "key"
    t.text     "parameters"
    t.string   "recipient_type"
    t.integer  "recipient_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "associable_type"
    t.integer  "associable_id"
    t.index ["associable_type", "associable_id"], name: "index_activities_on_associable_type_and_associable_id", using: :btree
    t.index ["owner_id", "owner_type"], name: "index_activities_on_owner_id_and_owner_type", using: :btree
    t.index ["recipient_id", "recipient_type"], name: "index_activities_on_recipient_id_and_recipient_type", using: :btree
    t.index ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type", using: :btree
  end

  create_table "addresses", force: :cascade do |t|
    t.string   "owner_type"
    t.integer  "owner_id"
    t.string   "address"
    t.string   "street"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "county"
    t.hstore   "data",       default: {}
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["city"], name: "index_addresses_on_city", using: :btree
    t.index ["owner_type", "owner_id"], name: "index_addresses_on_owner_type_and_owner_id", using: :btree
  end

  create_table "announcements", force: :cascade do |t|
    t.text     "message"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "api_responses", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "api_type"
    t.datetime "api_called_at"
    t.string   "status"
    t.string   "message"
    t.index ["api_type"], name: "index_api_responses_on_api_type", using: :btree
    t.index ["created_at"], name: "index_api_responses_on_created_at", using: :btree
  end

  create_table "authorizations", force: :cascade do |t|
    t.string   "provider"
    t.string   "uid"
    t.integer  "user_id"
    t.string   "token"
    t.string   "secret"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "name"
    t.string   "link"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "refresh_token"
    t.boolean  "refresh_expires"
    t.datetime "refresh_token_expires_at"
    t.string   "email"
    t.string   "access_token"
    t.integer  "expires_in"
    t.boolean  "via_inbox_app",            default: false
    t.index ["provider"], name: "index_authorizations_on_provider", using: :btree
    t.index ["uid"], name: "index_authorizations_on_uid", using: :btree
    t.index ["user_id"], name: "index_authorizations_on_user_id", using: :btree
  end

  create_table "checkouts", force: :cascade do |t|
    t.integer  "user_id",                         null: false
    t.integer  "plan_id",                         null: false
    t.string   "stripe_coupon_id"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.boolean  "trial",            default: true, null: false
    t.index ["plan_id"], name: "index_checkouts_on_plan_id", using: :btree
    t.index ["stripe_coupon_id"], name: "index_checkouts_on_stripe_coupon_id", using: :btree
    t.index ["user_id"], name: "index_checkouts_on_user_id", using: :btree
  end

  create_table "comments", force: :cascade do |t|
    t.text     "content"
    t.string   "commentable_type"
    t.integer  "commentable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.index ["commentable_id", "commentable_type"], name: "index_comments_on_commentable_id_and_commentable_type", using: :btree
    t.index ["user_id"], name: "index_comments_on_user_id", using: :btree
  end

  create_table "contact_activities", force: :cascade do |t|
    t.string   "activity_type"
    t.string   "subject"
    t.datetime "completed_at"
    t.text     "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "contact_id"
    t.boolean  "asked_for_referral", default: false
    t.boolean  "received_referral"
    t.boolean  "replied_to",         default: false
    t.string   "activity_for"
    t.integer  "lead_id"
    t.index ["activity_for"], name: "index_contact_activities_on_activity_for", using: :btree
    t.index ["activity_type"], name: "index_contact_activities_on_activity_type", using: :btree
    t.index ["asked_for_referral"], name: "index_contact_activities_on_asked_for_referral", using: :btree
    t.index ["contact_id"], name: "index_contact_activities_on_contact_id", using: :btree
    t.index ["lead_id"], name: "index_contact_activities_on_lead_id", using: :btree
    t.index ["received_referral"], name: "index_contact_activities_on_received_referral", using: :btree
    t.index ["replied_to"], name: "index_contact_activities_on_replied_to", using: :btree
    t.index ["user_id"], name: "index_contact_activities_on_user_id", using: :btree
  end

  create_table "contacts", force: :cascade do |t|
    t.string   "name"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "spouse_first_name"
    t.string   "envelope_salutation"
    t.string   "letter_salutation"
    t.string   "company"
    t.string   "profession"
    t.integer  "grade"
    t.datetime "last_contacted_at"
    t.integer  "minutes_since_last_contacted"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "last_note_sent_at"
    t.datetime "next_note_at"
    t.datetime "last_called_at"
    t.datetime "next_call_at"
    t.datetime "last_visited_at"
    t.datetime "next_visit_at"
    t.hstore   "data",                         default: {}
    t.string   "title"
    t.string   "import_source_type"
    t.integer  "import_source_id"
    t.datetime "graded_at"
    t.integer  "created_by_user_id"
    t.integer  "avatar_color",                 default: 0
    t.boolean  "active",                       default: true
    t.datetime "inactive_at"
    t.datetime "last_activity_at"
    t.datetime "next_activity_at"
    t.string   "spouse_last_name"
    t.string   "suggested_first_name"
    t.string   "suggested_last_name"
    t.string   "suggested_location"
    t.string   "suggested_organization_name"
    t.string   "suggested_job_title"
    t.string   "suggested_linkedin_bio"
    t.string   "search_status"
    t.datetime "suggestion_received"
    t.string   "mandrill_message_id_list",     default: [],   array: true
    t.string   "mandrill_message_ids_string"
    t.string   "mandrill_email_interactions",  default: ""
    t.string   "birthday"
    t.string   "suggested_facebook_url"
    t.string   "suggested_linkedin_url"
    t.string   "suggested_twitter_url"
    t.string   "suggested_googleplus_url"
    t.string   "suggested_instagram_url"
    t.string   "suggested_youtube_url"
    t.integer  "search_status_code"
    t.string   "search_status_message"
    t.string   "google_api_contact_id"
    t.string   "yahoo_contact_id"
    t.string   "email"
    t.string   "phone_number"
    t.index ["active"], name: "index_contacts_on_active", using: :btree
    t.index ["created_by_user_id"], name: "index_contacts_on_created_by_user_id", using: :btree
    t.index ["email"], name: "index_contacts_on_email", using: :btree
    t.index ["grade"], name: "index_contacts_on_grade", using: :btree
    t.index ["name"], name: "index_contacts_on_name", using: :btree
    t.index ["phone_number"], name: "index_contacts_on_phone_number", using: :btree
    t.index ["user_id", "active", "grade"], name: "index_contacts_on_user_id_and_active_and_grade", using: :btree
    t.index ["user_id"], name: "index_contacts_on_user_id", using: :btree
  end

  create_table "contingencies", force: :cascade do |t|
    t.integer  "contract_id"
    t.string   "name"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["contract_id"], name: "index_contingencies_on_contract_id", using: :btree
  end

  create_table "contracts", force: :cascade do |t|
    t.integer  "property_id"
    t.decimal  "offer_price"
    t.decimal  "closing_price"
    t.datetime "offer_accepted_date_at"
    t.datetime "closing_date_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status"
    t.string   "commission_type"
    t.decimal  "commission_rate"
    t.decimal  "commission_flat_fee"
    t.string   "referral_fee_type"
    t.decimal  "referral_fee_rate"
    t.decimal  "referral_fee_flat_fee"
    t.decimal  "additional_fees"
    t.datetime "offer_deadline_at"
    t.string   "buyer"
    t.string   "buyer_agent"
    t.string   "seller"
    t.string   "seller_agent"
    t.string   "contract_type"
    t.integer  "lead_id"
    t.boolean  "broker_commission_custom",         default: false
    t.string   "broker_commission_type"
    t.decimal  "broker_commission_percentage"
    t.decimal  "broker_commission_fee"
    t.decimal  "commission_percentage_total"
    t.decimal  "commission_percentage_buyer_side"
    t.decimal  "commission_fee_total"
    t.decimal  "commission_fee_buyer_side"
    t.index ["lead_id"], name: "index_contracts_on_lead_id", using: :btree
    t.index ["property_id"], name: "index_contracts_on_property_id", using: :btree
    t.index ["status"], name: "index_contracts_on_status", using: :btree
  end

  create_table "csv_file_invalid_records", force: :cascade do |t|
    t.integer  "csv_file_id"
    t.text     "original_row"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "contact_errors"
  end

  create_table "csv_files", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "csv"
    t.string   "state"
    t.hstore   "import_result",           default: {}
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "total_parsed_records",    default: 0
    t.integer  "total_imported_records",  default: 0
    t.integer  "total_failed_records",    default: 0
    t.string   "total_import_time_in_ms"
    t.index ["user_id"], name: "index_csv_files_on_user_id", using: :btree
  end

  create_table "cursors", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "cursor_id"
    t.string   "object_id"
    t.string   "event"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.text     "object_type", default: "", null: false
    t.text     "data"
    t.index ["cursor_id"], name: "index_cursors_on_cursor_id", using: :btree
    t.index ["event"], name: "index_cursors_on_event", using: :btree
    t.index ["object_id"], name: "index_cursors_on_object_id", using: :btree
    t.index ["object_type"], name: "index_cursors_on_object_type", using: :btree
    t.index ["user_id"], name: "index_cursors_on_user_id", using: :btree
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0
    t.integer  "attempts",   default: 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree
  end

  create_table "email_addresses", force: :cascade do |t|
    t.string   "owner_type"
    t.integer  "owner_id"
    t.string   "email"
    t.string   "email_type"
    t.boolean  "primary"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["email"], name: "index_email_addresses_on_email", using: :btree
    t.index ["email_type"], name: "index_email_addresses_on_email_type", using: :btree
    t.index ["owner_id", "owner_type", "email", "primary"], name: "email_addresses_powerful_index", using: :btree
    t.index ["owner_id", "owner_type", "email"], name: "index_email_addresses_on_owner_id_and_owner_type_and_email", using: :btree
    t.index ["owner_id", "owner_type", "primary"], name: "index_email_addresses_on_owner_id_and_owner_type_and_primary", using: :btree
    t.index ["owner_id", "owner_type"], name: "index_email_addresses_on_owner_id_and_owner_type", using: :btree
    t.index ["owner_type", "email", "primary"], name: "index_email_addresses_on_owner_type_and_email_and_primary", using: :btree
    t.index ["primary"], name: "index_email_addresses_on_primary", using: :btree
  end

  create_table "email_campaigns", force: :cascade do |t|
    t.string   "title"
    t.text     "content"
    t.string   "image"
    t.datetime "scheduled_delivery_at"
    t.datetime "delivered_at"
    t.integer  "user_id"
    t.boolean  "delivered"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "message_id"
    t.string   "email_status"
    t.string   "message_id_list",         default: [],    array: true
    t.integer  "contact_list",            default: [],    array: true
    t.integer  "campaign_status",         default: 0
    t.string   "name"
    t.string   "message_ids_string"
    t.string   "contact_ids_string"
    t.integer  "unique_clicks",           default: 0
    t.integer  "unique_opens",            default: 0
    t.integer  "total_clicks",            default: 0
    t.integer  "total_opens",             default: 0
    t.integer  "successful_deliveries",   default: 0
    t.integer  "last_opened",             default: 0
    t.integer  "last_clicked",            default: 0
    t.text     "contacts"
    t.text     "groups"
    t.string   "subject"
    t.boolean  "track_opens",             default: true
    t.boolean  "track_clicks",            default: true
    t.boolean  "send_generic_report",     default: true
    t.boolean  "custom_delivery_time",    default: false
    t.string   "color_scheme"
    t.text     "custom_message"
    t.boolean  "display_custom_message",  default: false
    t.string   "selected_groups",         default: [],    array: true
    t.integer  "selected_grades",         default: [],    array: true
    t.string   "recipient_selector_type"
    t.string   "campaign_type"
    t.index ["campaign_status"], name: "index_email_campaigns_on_campaign_status", using: :btree
    t.index ["email_status"], name: "index_email_campaigns_on_email_status", using: :btree
    t.index ["user_id"], name: "index_email_campaigns_on_user_id", using: :btree
  end

  create_table "email_messages", force: :cascade do |t|
    t.string   "message_id"
    t.string   "thread_id"
    t.string   "subject"
    t.string   "from_email"
    t.string   "to"
    t.string   "cc"
    t.string   "bcc"
    t.datetime "received_at"
    t.string   "snippet"
    t.text     "body"
    t.boolean  "unread"
    t.string   "account"
    t.integer  "user_id"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "from_name"
    t.string   "to_email_addresses", default: [],              array: true
    t.index ["account"], name: "index_email_messages_on_account", using: :btree
    t.index ["from_email"], name: "index_email_messages_on_from_email", using: :btree
    t.index ["message_id"], name: "index_email_messages_on_message_id", using: :btree
    t.index ["thread_id"], name: "index_email_messages_on_thread_id", using: :btree
    t.index ["user_id"], name: "index_email_messages_on_user_id", using: :btree
  end

  create_table "failed_api_imports", force: :cascade do |t|
    t.string   "message"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["user_id"], name: "index_failed_api_imports_on_user_id", using: :btree
  end

  create_table "frequencies", force: :cascade do |t|
    t.string   "freq_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "freq_order"
  end

  create_table "goals", force: :cascade do |t|
    t.decimal  "desired_annual_income"
    t.decimal  "est_business_expenses"
    t.decimal  "portion_of_agent_split"
    t.decimal  "gross_commission_goal"
    t.decimal  "avg_commission_rate"
    t.decimal  "gross_sales_vol_required"
    t.decimal  "avg_price_in_area"
    t.decimal  "annual_transaction_goal"
    t.decimal  "qtrly_transaction_goal"
    t.decimal  "referrals_for_one_close",           default: "5.0"
    t.decimal  "contacts_to_generate_one_referral", default: "20.0"
    t.decimal  "contacts_need_per_month"
    t.decimal  "calls_required_wkly"
    t.decimal  "note_required_wkly"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "monthly_transaction_goal"
    t.integer  "user_id"
    t.decimal  "total_weekly_effort"
    t.decimal  "visits_required_wkly"
    t.integer  "daily_calls_goal",                  default: 0
    t.integer  "daily_notes_goal",                  default: 0
    t.integer  "daily_visits_goal",                 default: 0
    t.index ["user_id"], name: "index_goals_on_user_id", using: :btree
  end

  create_table "images", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "attachable_type"
    t.integer  "attachable_id"
    t.string   "file"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "height"
    t.integer  "width"
    t.index ["attachable_type", "attachable_id"], name: "index_images_on_attachable_type_and_attachable_id", using: :btree
    t.index ["user_id"], name: "index_images_on_user_id", using: :btree
  end

  create_table "inbox_message_activities", force: :cascade do |t|
    t.string   "activity_event"
    t.datetime "ts"
    t.integer  "inbox_message_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["activity_event"], name: "index_inbox_message_activities_on_activity_event", using: :btree
    t.index ["inbox_message_id"], name: "index_inbox_message_activities_on_inbox_message_id", using: :btree
  end

  create_table "inbox_messages", force: :cascade do |t|
    t.string   "opens_tracking_id"
    t.string   "clicks_tracking_id"
    t.string   "inbox_message_id"
    t.boolean  "opened"
    t.boolean  "clicked"
    t.string   "sent_to_email_address"
    t.integer  "user_id"
    t.integer  "lead_id"
    t.integer  "contact_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "client_response_last_checked_at"
    t.index ["clicks_tracking_id"], name: "index_inbox_messages_on_clicks_tracking_id", using: :btree
    t.index ["contact_id"], name: "index_inbox_messages_on_contact_id", using: :btree
    t.index ["inbox_message_id"], name: "index_inbox_messages_on_inbox_message_id", using: :btree
    t.index ["lead_id"], name: "index_inbox_messages_on_lead_id", using: :btree
    t.index ["opens_tracking_id"], name: "index_inbox_messages_on_opens_tracking_id", using: :btree
    t.index ["sent_to_email_address"], name: "index_inbox_messages_on_sent_to_email_address", using: :btree
    t.index ["user_id"], name: "index_inbox_messages_on_user_id", using: :btree
  end

  create_table "invitations", force: :cascade do |t|
    t.integer  "team_id",      null: false
    t.string   "email",        null: false
    t.string   "code",         null: false
    t.datetime "accepted_at"
    t.integer  "sender_id",    null: false
    t.integer  "recipient_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["code"], name: "index_invitations_on_code", using: :btree
    t.index ["team_id"], name: "index_invitations_on_team_id", using: :btree
  end

  create_table "lead_emails", force: :cascade do |t|
    t.string   "recipient"
    t.string   "to"
    t.string   "from"
    t.string   "subject"
    t.string   "date"
    t.string   "token"
    t.text     "text"
    t.text     "html"
    t.text     "headers"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "importing_state",  default: "received"
    t.string   "nylas_message_id"
    t.integer  "user_id"
    t.index ["recipient"], name: "index_lead_emails_on_recipient", using: :btree
  end

  create_table "lead_group_broadcast_settings", force: :cascade do |t|
    t.integer "lead_setting_id"
    t.integer "lead_group_id"
    t.index ["lead_group_id"], name: "index_lead_group_broadcast_settings_on_lead_group_id", using: :btree
    t.index ["lead_setting_id"], name: "index_lead_group_broadcast_settings_on_lead_setting_id", using: :btree
  end

  create_table "lead_groups", force: :cascade do |t|
    t.string   "name",       default: "", null: false
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["user_id"], name: "index_lead_groups_on_user_id", using: :btree
  end

  create_table "lead_groups_settings", force: :cascade do |t|
    t.integer "lead_setting_id"
    t.integer "lead_group_id"
    t.index ["lead_group_id"], name: "index_lead_groups_settings_on_lead_group_id", using: :btree
    t.index ["lead_setting_id"], name: "index_lead_groups_settings_on_lead_setting_id", using: :btree
  end

  create_table "lead_groups_users", force: :cascade do |t|
    t.integer "user_id"
    t.integer "lead_group_id"
    t.index ["lead_group_id"], name: "index_lead_groups_users_on_lead_group_id", using: :btree
    t.index ["user_id"], name: "index_lead_groups_users_on_user_id", using: :btree
  end

  create_table "lead_settings", force: :cascade do |t|
    t.boolean  "email_auto_respond",                  default: true
    t.string   "auto_respond_subject"
    t.text     "auto_respond_body"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "forward_lead_to_group",               default: false
    t.integer  "forward_after_minutes",               default: 0
    t.boolean  "broadcast_lead_to_group",             default: false
    t.integer  "broadcast_after_minutes",             default: 5
    t.boolean  "parse_trulia_leads",                  default: true
    t.boolean  "parse_realtor_leads",                 default: true
    t.boolean  "parse_zillow_leads",                  default: true
    t.boolean  "new_lead_sms_notification",           default: true
    t.boolean  "new_lead_email_notification",         default: true
    t.boolean  "lead_claimed_sms_notification",       default: true
    t.boolean  "lead_claimed_email_notification",     default: true
    t.boolean  "lead_unclaimed_sms_notification",     default: true
    t.boolean  "lead_unclaimed_email_notification",   default: true
    t.boolean  "away",                                default: false
    t.datetime "vacation_end_at"
    t.boolean  "quiet_hours",                         default: false
    t.integer  "quiet_hours_start"
    t.integer  "quiet_hours_end"
    t.boolean  "receive_sms_on_weekends",             default: true
    t.integer  "notification_time_interval",          default: 1
    t.boolean  "will_receive_morning_awaiting",       default: false
    t.boolean  "followup_lead_sms_permission",        default: false
    t.boolean  "followup_lead_email_permission",      default: false
    t.boolean  "daily_leads_recap",                   default: true
    t.boolean  "daily_pipeline",                      default: true
    t.boolean  "parse_emails_with_inbox",             default: false
    t.boolean  "receive_daily_client_activity_recap"
    t.boolean  "next_action_reminder_sms",            default: false, null: false
    t.boolean  "daily_overall_recap",                 default: true
    t.index ["user_id"], name: "index_lead_settings_on_user_id", using: :btree
  end

  create_table "lead_sources", force: :cascade do |t|
    t.string   "name"
    t.integer  "lead_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["lead_type_id"], name: "index_lead_sources_on_lead_type_id", using: :btree
    t.index ["name"], name: "index_lead_sources_on_name", using: :btree
  end

  create_table "lead_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["name"], name: "index_lead_types_on_name", using: :btree
  end

  create_table "leads", force: :cascade do |t|
    t.integer  "contact_id"
    t.integer  "user_id"
    t.integer  "status"
    t.string   "client_type"
    t.boolean  "rental"
    t.string   "lead_type_old"
    t.string   "lead_source_old"
    t.datetime "incoming_lead_at"
    t.integer  "stage"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.decimal  "min_price_range"
    t.decimal  "max_price_range"
    t.integer  "referring_contact_id"
    t.decimal  "referral_fees"
    t.integer  "timeframe"
    t.boolean  "claimed"
    t.integer  "property_type"
    t.string   "buyer_area_of_interest"
    t.datetime "lost_date_at"
    t.string   "reason_for_loss"
    t.datetime "pause_date_at"
    t.string   "reason_for_pause"
    t.decimal  "amount_owed"
    t.boolean  "buyer_prequalified"
    t.decimal  "prequalification_amount"
    t.string   "import_source_type"
    t.integer  "import_source_id"
    t.string   "state"
    t.integer  "created_by_user_id"
    t.datetime "last_broadcast_at"
    t.decimal  "displayed_price"
    t.decimal  "displayed_commission_rate"
    t.decimal  "displayed_gross_commission"
    t.datetime "displayed_closing_date_at"
    t.datetime "attempted_contact_at"
    t.datetime "unpause_date_at"
    t.integer  "incoming_lead_price",                    default: 0
    t.integer  "initial_status_when_created"
    t.decimal  "time_before_attempted_contact"
    t.integer  "lead_source_id"
    t.integer  "lead_type_id"
    t.decimal  "displayed_net_commission"
    t.integer  "next_action_id"
    t.integer  "incomplete_tasks_count",                 default: 0
    t.decimal  "additional_fees"
    t.string   "referral_fee_type"
    t.decimal  "referral_fee_rate"
    t.decimal  "referral_fee_flat_fee"
    t.datetime "original_list_date_at"
    t.decimal  "original_list_price"
    t.integer  "stage_lost"
    t.integer  "stage_paused"
    t.datetime "lead_followup_reminder_time"
    t.boolean  "lead_followup_reminder_attempted",       default: false
    t.string   "displayed_commission_type"
    t.decimal  "displayed_commission_fee"
    t.string   "displayed_referral_type"
    t.decimal  "displayed_referral_percentage"
    t.decimal  "displayed_referral_fee"
    t.string   "displayed_broker_commission_type"
    t.decimal  "displayed_broker_commission_percentage"
    t.decimal  "displayed_broker_commission_fee"
    t.boolean  "displayed_broker_commission_custom",     default: false
    t.integer  "first_email_attempted_id"
    t.text     "junk_reason"
    t.datetime "snoozed_at"
    t.datetime "snoozed_until"
    t.integer  "snoozed_by_id"
    t.boolean  "displayed_broker_has_franchise_fee",     default: false, null: false
    t.decimal  "displayed_broker_franchise_fee"
    t.datetime "follow_up_at"
    t.datetime "last_follow_up_at"
    t.integer  "contacted_status",                       default: 0
    t.decimal  "displayed_additional_fees"
    t.string   "reason_for_long_term_prospect"
    t.datetime "long_term_prospect_remind_me_at"
    t.index ["client_type"], name: "index_leads_on_client_type", using: :btree
    t.index ["contact_id"], name: "index_leads_on_contact_id", using: :btree
    t.index ["contacted_status"], name: "index_leads_on_contacted_status", using: :btree
    t.index ["created_by_user_id"], name: "index_leads_on_created_by_user_id", using: :btree
    t.index ["first_email_attempted_id"], name: "index_leads_on_first_email_attempted_id", using: :btree
    t.index ["import_source_type", "import_source_id"], name: "index_leads_on_import_source_type_and_import_source_id", using: :btree
    t.index ["lead_source_id"], name: "index_leads_on_lead_source_id", using: :btree
    t.index ["lead_type_id"], name: "index_leads_on_lead_type_id", using: :btree
    t.index ["next_action_id"], name: "index_leads_on_next_action_id", using: :btree
    t.index ["property_type"], name: "index_leads_on_property_type", using: :btree
    t.index ["referring_contact_id"], name: "index_leads_on_referring_contact_id", using: :btree
    t.index ["snoozed_by_id"], name: "index_leads_on_snoozed_by_id", using: :btree
    t.index ["stage"], name: "index_leads_on_stage", using: :btree
    t.index ["stage_lost"], name: "index_leads_on_stage_lost", using: :btree
    t.index ["stage_paused"], name: "index_leads_on_stage_paused", using: :btree
    t.index ["state"], name: "index_leads_on_state", using: :btree
    t.index ["status"], name: "index_leads_on_status", using: :btree
    t.index ["user_id"], name: "index_leads_on_user_id", using: :btree
  end

  create_table "mandrill_message_activities", force: :cascade do |t|
    t.string   "message_event",       default: ""
    t.string   "ip",                  default: ""
    t.string   "location",            default: ""
    t.string   "ua",                  default: ""
    t.string   "url"
    t.integer  "ts"
    t.integer  "mandrill_message_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["mandrill_message_id"], name: "index_mandrill_message_activities_on_mandrill_message_id", using: :btree
  end

  create_table "mandrill_messages", force: :cascade do |t|
    t.string   "mandrill_id"
    t.integer  "user_id"
    t.integer  "contact_id"
    t.integer  "email_campaign_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "opens",             default: 0
    t.string   "opens_detail",      default: ""
    t.integer  "clicks",            default: 0
    t.string   "clicks_detail",     default: ""
    t.string   "state",             default: "0"
    t.string   "activity_ts_list",  default: ""
    t.integer  "last_clicked",      default: 0
    t.integer  "last_opened",       default: 0
    t.index ["contact_id"], name: "index_mandrill_messages_on_contact_id", using: :btree
    t.index ["email_campaign_id"], name: "index_mandrill_messages_on_email_campaign_id", using: :btree
    t.index ["mandrill_id"], name: "index_mandrill_messages_on_mandrill_id", using: :btree
    t.index ["state"], name: "index_mandrill_messages_on_state", using: :btree
    t.index ["user_id"], name: "index_mandrill_messages_on_user_id", using: :btree
  end

  create_table "market_cities", force: :cascade do |t|
    t.string   "name"
    t.integer  "market_county_id"
    t.integer  "market_state_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "market_counties", force: :cascade do |t|
    t.string   "name"
    t.integer  "market_state_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "market_reports", force: :cascade do |t|
    t.string   "location_type",                              null: false
    t.integer  "location_id",                                null: false
    t.datetime "report_date_at"
    t.integer  "average_list_price"
    t.integer  "median_list_price"
    t.integer  "average_days_on_market_listings"
    t.integer  "number_of_new_listings"
    t.integer  "number_of_sales"
    t.integer  "average_sales_price"
    t.integer  "median_sales_price"
    t.integer  "average_days_on_market_sold"
    t.decimal  "original_vs_sales_price_ratio_avg_for_sale"
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.integer  "number_of_listings"
    t.index ["location_type", "location_id"], name: "index_market_reports_on_location_type_and_location_id", using: :btree
  end

  create_table "market_states", force: :cascade do |t|
    t.string   "name"
    t.string   "abbreviation"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "market_zips", force: :cascade do |t|
    t.string   "name"
    t.integer  "market_city_id"
    t.integer  "market_county_id"
    t.integer  "market_state_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "media", force: :cascade do |t|
    t.string   "media_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "num_order"
  end

  create_table "mktcampaigns", force: :cascade do |t|
    t.string   "name"
    t.date     "start_date_at"
    t.date     "end_date_at"
    t.decimal  "cost"
    t.boolean  "recurring"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "media_id"
    t.integer  "frequency_id"
  end

  create_table "phone_numbers", force: :cascade do |t|
    t.string   "owner_type"
    t.integer  "owner_id"
    t.string   "number"
    t.string   "number_type"
    t.boolean  "primary"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["owner_id", "owner_type", "number", "primary"], name: "phone_numbers_powerful_index", using: :btree
    t.index ["owner_id", "owner_type", "number"], name: "index_phone_numbers_on_owner_id_and_owner_type_and_number", using: :btree
    t.index ["owner_id", "owner_type", "primary"], name: "index_phone_numbers_on_owner_id_and_owner_type_and_primary", using: :btree
    t.index ["owner_id", "owner_type"], name: "index_phone_numbers_on_owner_id_and_owner_type", using: :btree
    t.index ["owner_type", "number"], name: "index_phone_numbers_on_owner_type_and_number", using: :btree
  end

  create_table "plans", force: :cascade do |t|
    t.string   "name",                                  null: false
    t.string   "interval",            default: "month", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "sku",                                   null: false
    t.string   "short_description",                     null: false
    t.text     "description",                           null: false
    t.boolean  "active",              default: true,    null: false
    t.integer  "price_in_dollars",                      null: false
    t.text     "terms"
    t.boolean  "featured",            default: false,   null: false
    t.boolean  "annual",              default: false
    t.integer  "annual_plan_id"
    t.integer  "minimum_quantity",    default: 1,       null: false
    t.boolean  "includes_team_group", default: false,   null: false
    t.index ["annual_plan_id"], name: "index_plans_on_annual_plan_id", using: :btree
  end

  create_table "print_campaign_messages", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "contact_id"
    t.integer  "print_campaign_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "print_campaigns", force: :cascade do |t|
    t.string   "name"
    t.integer  "title"
    t.integer  "recipient_type"
    t.string   "label_size"
    t.integer  "user_id"
    t.integer  "contact_id"
    t.integer  "lead_id"
    t.boolean  "printed"
    t.string   "groups",         default: [],              array: true
    t.integer  "grades",         default: [],              array: true
    t.text     "contacts"
    t.integer  "quantity"
    t.datetime "pdf_created_at"
    t.datetime "printed_at"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "products", force: :cascade do |t|
    t.string   "name"
    t.string   "sku"
    t.string   "tagline"
    t.string   "call_to_action"
    t.string   "short_description"
    t.text     "description"
    t.string   "type",                                       null: false
    t.boolean  "active"
    t.text     "questions"
    t.text     "terms"
    t.text     "alternative_description"
    t.string   "product_image_file_name"
    t.string   "product_image_file_size"
    t.string   "product_image_content_type"
    t.string   "product_image_updated_at"
    t.boolean  "promoted",                   default: false, null: false
    t.string   "slug",                                       null: false
    t.text     "resources",                  default: "",    null: false
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.index ["slug"], name: "index_products_on_slug", using: :btree
  end

  create_table "properties", force: :cascade do |t|
    t.integer  "lead_id"
    t.integer  "user_id"
    t.decimal  "list_price"
    t.string   "mls_number"
    t.string   "property_url"
    t.boolean  "rental"
    t.datetime "original_list_date_at"
    t.decimal  "original_list_price"
    t.datetime "listing_expires_at"
    t.string   "commission_type"
    t.decimal  "commission_percentage"
    t.decimal  "commission_fee"
    t.decimal  "referral_fees"
    t.decimal  "additional_fees"
    t.decimal  "initial_client_valuation"
    t.decimal  "initial_agent_valuation"
    t.integer  "bedrooms"
    t.decimal  "bathrooms"
    t.integer  "sq_feet"
    t.decimal  "lot_size"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "property_type"
    t.string   "transaction_type"
    t.boolean  "initial_property_interested_in",   default: false
    t.string   "level_of_interest"
    t.integer  "contracts_count",                  default: 0
    t.string   "referral_fee_type"
    t.decimal  "referral_fee_rate"
    t.decimal  "referral_fee_flat_fee"
    t.decimal  "commission_percentage_total"
    t.decimal  "commission_percentage_buyer_side"
    t.decimal  "commission_fee_total"
    t.decimal  "commission_fee_buyer_side"
    t.index ["lead_id"], name: "index_properties_on_lead_id", using: :btree
    t.index ["transaction_type"], name: "index_properties_on_transaction_type", using: :btree
    t.index ["user_id"], name: "index_properties_on_user_id", using: :btree
  end

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
    t.index ["updated_at"], name: "index_sessions_on_updated_at", using: :btree
  end

  create_table "showings", force: :cascade do |t|
    t.integer  "lead_id"
    t.integer  "status"
    t.string   "address1"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.datetime "date_time"
    t.text     "comments"
    t.string   "mls_number"
    t.string   "listing_agent"
    t.boolean  "email_request_to_agent"
    t.boolean  "requested"
    t.boolean  "confirmed"
    t.decimal  "list_price"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stripe_webhooks", force: :cascade do |t|
    t.string   "event_type"
    t.integer  "amount"
    t.string   "info"
    t.string   "customer_id"
    t.integer  "ts"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["user_id"], name: "index_stripe_webhooks_on_user_id", using: :btree
  end

  create_table "subscriptions", force: :cascade do |t|
    t.integer  "plan_id",                                                null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "account_balance"
    t.date     "deactivated_on"
    t.date     "scheduled_for_cancellation_on"
    t.string   "plan_type",                     default: "StandardPlan", null: false
    t.decimal  "next_payment_amount",           default: "0.0",          null: false
    t.date     "next_payment_on"
    t.string   "stripe_id"
    t.integer  "user_id"
    t.string   "card_type"
    t.string   "card_last_four_digits"
    t.date     "card_expires_on"
    t.datetime "trial_ends_at"
    t.index ["plan_id"], name: "index_subscriptions_on_plan_id", using: :btree
    t.index ["stripe_id"], name: "index_subscriptions_on_stripe_id", using: :btree
    t.index ["user_id"], name: "index_subscriptions_on_user_id", using: :btree
  end

  create_table "survey_results", force: :cascade do |t|
    t.boolean  "completed",                     default: false
    t.string   "survey_token"
    t.string   "browser"
    t.string   "platform"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.string   "user_agent"
    t.string   "referer"
    t.string   "network_id"
    t.text     "promotion_code"
    t.text     "first_name"
    t.text     "last_name"
    t.text     "email"
    t.integer  "zip_code"
    t.integer  "years_experience"
    t.string   "workload"
    t.text     "other_work",                    default: [],                 array: true
    t.integer  "average_home_price"
    t.integer  "past_year_total_transaction"
    t.integer  "past_year_income"
    t.string   "next_year_plans"
    t.integer  "desired_annual_income"
    t.integer  "est_business_expenses"
    t.boolean  "pays_monthly_broker_fee"
    t.integer  "monthly_broker_fees_paid"
    t.boolean  "franchise_fee"
    t.decimal  "franchise_fee_per_transaction"
    t.string   "commission_split_type"
    t.decimal  "agent_percentage_split"
    t.integer  "broker_fee_per_transaction"
    t.boolean  "broker_fee_alternative"
    t.decimal  "broker_fee_alternative_split"
    t.boolean  "per_transaction_fee_capped"
    t.integer  "transaction_fee_cap"
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.decimal  "avg_commission_rate"
  end

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.string   "taggable_type"
    t.integer  "taggable_id"
    t.string   "tagger_type"
    t.integer  "tagger_id"
    t.string   "context",       limit: 128
    t.datetime "created_at"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
    t.index ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id", using: :btree
  end

  create_table "tags", force: :cascade do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true, using: :btree
  end

  create_table "tasks", force: :cascade do |t|
    t.string   "subject"
    t.integer  "assigned_to_id"
    t.datetime "due_date_at"
    t.boolean  "completed",       default: false, null: false
    t.string   "taskable_type"
    t.integer  "taskable_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "completed_at"
    t.string   "type_associated"
    t.integer  "completed_by_id"
    t.boolean  "is_next_action",  default: false, null: false
    t.index ["assigned_to_id"], name: "index_tasks_on_assigned_to_id", using: :btree
    t.index ["completed_by_id"], name: "index_tasks_on_completed_by_id", using: :btree
    t.index ["taskable_id", "taskable_type"], name: "index_tasks_on_taskable_id_and_taskable_type", using: :btree
    t.index ["type_associated"], name: "index_tasks_on_type_associated", using: :btree
    t.index ["user_id"], name: "index_tasks_on_user_id", using: :btree
  end

  create_table "team_groups", force: :cascade do |t|
    t.integer  "subscription_id", null: false
    t.string   "name",            null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["subscription_id"], name: "index_team_groups_on_subscription_id", using: :btree
  end

  create_table "teammates", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "team_id"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["user_id", "team_id"], name: "index_teammates_on_user_id_and_team_id", unique: true, using: :btree
  end

  create_table "teams", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["user_id"], name: "index_teams_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                                          default: "",    null: false
    t.string   "encrypted_password",                             default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                                  default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "super_admin",                                    default: false
    t.string   "name"
    t.string   "mobile_number"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "time_zone"
    t.integer  "team_id"
    t.integer  "wkly_calls_counter",                             default: 0
    t.integer  "wkly_notes_counter",                             default: 0
    t.integer  "wkly_visits_counter",                            default: 0
    t.string   "ab_email_address",                                               null: false
    t.boolean  "initial_setup",                                  default: false
    t.string   "real_estate_experience"
    t.string   "contacts_database_storage"
    t.string   "company"
    t.string   "personal_website"
    t.string   "office_number"
    t.string   "fax_number"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "country"
    t.boolean  "subscribed",                                     default: false
    t.string   "company_website"
    t.string   "lead_form_key"
    t.integer  "contacts_count",                                 default: 0
    t.integer  "ungraded_contacts_count",                        default: 0
    t.integer  "dly_calls_counter",                              default: 0
    t.integer  "dly_notes_counter",                              default: 0
    t.integer  "dly_visits_counter",                             default: 0
    t.integer  "avatar_color",                                   default: 0
    t.string   "commission_split_type"
    t.decimal  "agent_percentage_split"
    t.decimal  "broker_percentage_split"
    t.decimal  "monthly_broker_fees_paid"
    t.decimal  "annual_broker_fees_paid"
    t.decimal  "broker_fee_per_transaction"
    t.boolean  "broker_fee_alternative",                         default: false
    t.decimal  "broker_fee_alternative_split"
    t.boolean  "per_transaction_fee_capped",                     default: false
    t.integer  "transaction_fee_cap"
    t.integer  "number_of_closed_leads_YTD",                     default: 0
    t.boolean  "show_narrow_main_nav_bar",                       default: false
    t.string   "twitter_token"
    t.string   "twitter_secret"
    t.string   "nylas_token"
    t.string   "nylas_connected_email_account"
    t.string   "stripe_customer_id"
    t.string   "billing_first_name",                             default: ""
    t.string   "billing_last_name",                              default: ""
    t.string   "billing_address",                                default: ""
    t.string   "billing_address_2",                              default: ""
    t.string   "billing_email_address",                          default: ""
    t.string   "billing_organization",                           default: ""
    t.string   "billing_state",                                  default: ""
    t.string   "billing_city",                                   default: ""
    t.string   "billing_zip_code",                               default: ""
    t.string   "billing_country",                                default: ""
    t.string   "profile_pic"
    t.boolean  "franchise_fee",                                  default: false, null: false
    t.decimal  "franchise_fee_per_transaction"
    t.string   "nilas_account_status"
    t.datetime "nilas_trial_status_set_at"
    t.datetime "account_marked_inactive_at"
    t.datetime "subscription_account_status_marked_inactive_at"
    t.string   "nilas_calendar_setting_id"
    t.integer  "subscription_account_status",                    default: 1
    t.string   "last_cursor"
    t.integer  "team_group_id"
    t.string   "nylas_account_id"
    t.boolean  "show_beta_features",                             default: false, null: false
    t.text     "email_signature"
    t.boolean  "email_signature_status"
    t.string   "authentication_token"
    t.string   "nylas_sync_status"
    t.string   "team_name"
    t.boolean  "email_campaign_track_opens",                     default: true
    t.boolean  "email_campaign_track_clicks",                    default: true
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["last_cursor"], name: "index_users_on_last_cursor", using: :btree
    t.index ["nylas_connected_email_account"], name: "index_users_on_nylas_connected_email_account", using: :btree
    t.index ["nylas_token"], name: "index_users_on_nylas_token", using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    t.index ["stripe_customer_id"], name: "index_users_on_stripe_customer_id", using: :btree
    t.index ["team_group_id"], name: "index_users_on_team_group_id", using: :btree
  end

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",  null: false
    t.integer  "item_id",    null: false
    t.string   "event",      null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree
  end

  add_foreign_key "checkouts", "plans", on_delete: :cascade
  add_foreign_key "checkouts", "users", on_delete: :cascade
  add_foreign_key "cursors", "users", on_delete: :cascade
  add_foreign_key "invitations", "teams", on_delete: :cascade
  add_foreign_key "team_groups", "subscriptions", on_delete: :cascade
end
