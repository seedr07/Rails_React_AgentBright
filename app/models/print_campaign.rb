# == Schema Information
#
# Table name: print_campaigns
#
#  contact_id     :integer
#  contacts       :text
#  created_at     :datetime         not null
#  grades         :integer          default([]), is an Array
#  groups         :string           default([]), is an Array
#  id             :integer          not null, primary key
#  label_size     :string
#  lead_id        :integer
#  name           :string
#  pdf_created_at :datetime
#  printed        :boolean
#  printed_at     :datetime
#  quantity       :integer
#  recipient_type :integer
#  title          :integer
#  updated_at     :datetime         not null
#  user_id        :integer
#

class PrintCampaign < ActiveRecord::Base

  has_many :print_campaign_messages, dependent: :destroy
  belongs_to :user

  accepts_nested_attributes_for :print_campaign_messages

  validates :label_size, presence: { message: "can't be blank" }
  # validates :recipient_type, presence: { message: "can't be blank" }
  validates :title, presence: { message: "can't be blank" }

  TITLE = [
    ["Christmas Card", 0],
    ["Spring Launch", 1],
    ["Open House", 2],
    ["House Sold", 3],
    ["Other", 4]
  ]

  LABEL_SIZES = [
    ["5160 - 1 x 2 5/8", "5160"],
    ["5163 - 1 x 2 5/8", "5163"],
    ["7160 - 2 1/2 x 1 1/2", "7160"]
  ]

  RECIPIENT_TYPE = [
    ["All Contacts", 0],
    ["Groups", 1],
    ["Grades", 2],
  ]

  scope :search_name, ->(search_term) { where("name ILIKE :search_term", search_term: "%#{search_term.downcase}%") }
  scope :labels_printed, -> { where(printed: true) }
  scope :labels_draft, -> { where(printed: false) }

  def title_to_s
    title.nil? ? " ? " : TITLE[title][0]
  end

end
