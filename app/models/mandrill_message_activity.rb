# == Schema Information
#
# Table name: mandrill_message_activities
#
#  created_at          :datetime
#  id                  :integer          not null, primary key
#  ip                  :string           default("")
#  location            :string           default("")
#  mandrill_message_id :integer
#  message_event       :string           default("")
#  ts                  :integer
#  ua                  :string           default("")
#  updated_at          :datetime
#  url                 :string
#
# Indexes
#
#  index_mandrill_message_activities_on_mandrill_message_id  (mandrill_message_id)
#

class MandrillMessageActivity < ActiveRecord::Base
  belongs_to :mandrill_message
end
