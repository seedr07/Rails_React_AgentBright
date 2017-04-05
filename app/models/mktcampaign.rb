# == Schema Information
#
# Table name: mktcampaigns
#
#  cost          :decimal(, )
#  created_at    :datetime
#  end_date_at   :date
#  frequency_id  :integer
#  id            :integer          not null, primary key
#  media_id      :integer
#  name          :string
#  recurring     :boolean
#  start_date_at :date
#  updated_at    :datetime
#

class Mktcampaign < ActiveRecord::Base

  belongs_to :media
  belongs_to :frequency

  validates :name, :media_id, :presence => true	
  validates :cost, :allow_blank => true, numericality: {greater_than_or_equal_to: 0}

  before_save :default_values
  after_save  :start_date_at_format, :end_date_at_format

  def frequency_to_s
    frequency.nil? ?  "N/A " : frequency.freq_type
  end

  def default_values
  	self.cost ||=0.0
   end

  def start_date_at_format
  	self.start_date_at.nil? ? " " :	start_date_at.to_s(:cal_date)
  end

  def end_date_at_format
      self.end_date_at.nil? ? " " :end_date_at.to_s(:cal_date)
  end

end
