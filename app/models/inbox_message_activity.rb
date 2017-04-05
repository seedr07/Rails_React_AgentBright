# == Schema Information
#
# Table name: inbox_message_activities
#
#  activity_event   :string
#  created_at       :datetime
#  id               :integer          not null, primary key
#  inbox_message_id :integer
#  ts               :datetime
#  updated_at       :datetime
#
# Indexes
#
#  index_inbox_message_activities_on_activity_event    (activity_event)
#  index_inbox_message_activities_on_inbox_message_id  (inbox_message_id)
#

class InboxMessageActivity < ActiveRecord::Base
  belongs_to :inbox_message
end
