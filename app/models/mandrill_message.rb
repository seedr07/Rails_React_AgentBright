# == Schema Information
#
# Table name: mandrill_messages
#
#  activity_ts_list  :string           default("")
#  clicks            :integer          default(0)
#  clicks_detail     :string           default("")
#  contact_id        :integer
#  created_at        :datetime
#  email_campaign_id :integer
#  id                :integer          not null, primary key
#  last_clicked      :integer          default(0)
#  last_opened       :integer          default(0)
#  mandrill_id       :string
#  opens             :integer          default(0)
#  opens_detail      :string           default("")
#  state             :string           default("0")
#  updated_at        :datetime
#  user_id           :integer
#
# Indexes
#
#  index_mandrill_messages_on_contact_id         (contact_id)
#  index_mandrill_messages_on_email_campaign_id  (email_campaign_id)
#  index_mandrill_messages_on_mandrill_id        (mandrill_id)
#  index_mandrill_messages_on_state              (state)
#  index_mandrill_messages_on_user_id            (user_id)
#

class MandrillMessage < ActiveRecord::Base
  include RecentActivity

  belongs_to :user
  belongs_to :contact
  belongs_to :email_campaign
  has_many :mandrill_message_activities, dependent: :destroy

  include PublicActivity::Model
  include ActivityWatcher

  tracked owner: proc { |controller, _| controller.current_user if controller },
          recipient: proc { |_, mandrill_message| mandrill_message.contact },
          params: {
            changes: :activity_parameters_changes,
            name: proc { |_, mandrill_message| mandrill_message.email_campaign.title }
          },
          on: {
            update: proc do |mandrill_message, _|
              mandrill_message.savable_activity?(mandrill_message.activity_parameters_changes)
            end
          }
end
