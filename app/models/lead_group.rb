# == Schema Information
#
# Table name: lead_groups
#
#  created_at :datetime
#  id         :integer          not null, primary key
#  name       :string           default(""), not null
#  updated_at :datetime
#  user_id    :integer
#
# Indexes
#
#  index_lead_groups_on_user_id  (user_id)
#

class LeadGroup < ActiveRecord::Base

  has_and_belongs_to_many :users
  belongs_to :owner, class_name: "User", inverse_of: :lead_groups_owned, foreign_key: "user_id"

  has_and_belongs_to_many :lead_forward_settings, class_name: "LeadSetting"
  has_and_belongs_to_many :lead_broadcast_settings, class_name: "LeadSetting", join_table: "lead_group_broadcast_settings"

  DURATION_BEFORE_LEAD_FORWARD = [["Immediately", 0], ["5 Minutes", 5], ["15 Minutes", 15], ["30 Minutes", 30], ["1 Hour", 60], ["4 Hours", 240]]
  DURATION_BEFORE_LEAD_BROADCAST = [["5 Minutes", 5], ["20 Minutes", 20], ["1 Hour", 60], ["4 Hours", 240], ["1 Day", 1440]]


  validates_presence_of :name

end
