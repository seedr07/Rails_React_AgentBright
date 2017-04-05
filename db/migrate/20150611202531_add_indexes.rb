class AddIndexes < ActiveRecord::Migration

  def change
    add_index :activities, [:associable_type, :associable_id]
    add_index :addresses, [:owner_type, :owner_id]
    add_index :addresses, :city
    add_index :api_responses, :created_at
    add_index :api_responses, :api_type
    add_index :authorizations, :provider
    add_index :authorizations, :uid
    add_index :checkouts, :stripe_coupon_id
    add_index :contact_activities, :activity_type
    add_index :contact_activities, :asked_for_referral
    add_index :contact_activities, :received_referral
    add_index :contact_activities, :replied_to
    add_index :contact_activities, :activity_for
    add_index :contacts, :name
    add_index :contacts, :grade
    add_index :contacts, :user_id
    add_index :contacts, :created_by_user_id
    add_index :contacts, :active
    add_index :contracts, :status
    add_index :contracts, :lead_id
    add_index :cursors, :object_id
    add_index :cursors, :object_type
    add_index :cursors, :event
    add_index :email_addresses, [:owner_type, :owner_id]
    add_index :email_addresses, :email
    add_index :email_addresses, :primary
    add_index :email_addresses, :email_type
    add_index :email_campaigns, :user_id
    add_index :email_campaigns, :email_status
    add_index :email_campaigns, :campaign_status
    add_index :email_messages, :message_id
    add_index :email_messages, :thread_id
    add_index :email_messages, :from_email
    add_index :email_messages, :account
    add_index :goals, :user_id
    add_index :images, :user_id
    add_index :images, [:attachable_type, :attachable_id]
    add_index :inbox_message_activities, :activity_event
    add_index :inbox_messages, :opens_tracking_id
    add_index :inbox_messages, :clicks_tracking_id
    add_index :inbox_messages, :inbox_message_id
    add_index :inbox_messages, :sent_to_email_address
    add_index :lead_group_broadcast_settings, :lead_setting_id
    add_index :lead_group_broadcast_settings, :lead_group_id
    add_index :lead_groups, :user_id
    add_index :lead_groups_settings, :lead_setting_id
    add_index :lead_groups_settings, :lead_group_id
    add_index :lead_groups_users, :user_id
    add_index :lead_groups_users, :lead_group_id
    add_index :lead_settings, :user_id
    add_index :lead_sources, :name
    add_index :lead_types, :name
    add_index :leads, :status
    add_index :leads, :client_type
    add_index :leads, :stage
    add_index :leads, :referring_contact_id
    add_index :leads, :property_type
    add_index :leads, :state
    add_index :leads, :created_by_user_id
    add_index :leads, :contacted_status
    add_index :leads, :lead_source_id
    add_index :leads, :lead_type_id
    add_index :leads, :next_action_id
    add_index :leads, :stage_lost
    add_index :leads, :stage_paused
    add_index :leads, :first_email_attempted_id
    add_index :leads, :snoozed_by_id
    add_index :mandrill_messages, :mandrill_id
    add_index :mandrill_messages, :state
    add_index :phone_numbers, [:owner_type, :owner_id]
    add_index :properties, :transaction_type
    add_index :tasks, :assigned_to_id
    add_index :tasks, :completed_by_id
    add_index :tasks, :type_associated
    add_index :teams, :user_id
    add_index :users, :inbox_token
    add_index :users, :last_cursor
    add_index :users, :stripe_customer_id
    add_index :users, :email_registered_with_inbox
  end

end
