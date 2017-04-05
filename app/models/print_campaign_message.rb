# == Schema Information
#
# Table name: print_campaign_messages
#
#  contact_id        :integer
#  created_at        :datetime         not null
#  id                :integer          not null, primary key
#  print_campaign_id :integer
#  updated_at        :datetime         not null
#  user_id           :integer
#

class PrintCampaignMessage < ActiveRecord::Base

  belongs_to :user
  belongs_to :contact
  belongs_to :print_campaign

  validates :contact, presence: true
  validates :print_campaign, presence: true

end
