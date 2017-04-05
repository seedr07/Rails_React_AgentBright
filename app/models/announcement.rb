# == Schema Information
#
# Table name: announcements
#
#  created_at :datetime
#  ends_at    :datetime
#  id         :integer          not null, primary key
#  message    :text
#  starts_at  :datetime
#  updated_at :datetime
#

class Announcement < ActiveRecord::Base

  before_save :formatted_starts_at, :formatted_ends_at

  validates :message, :starts_at,  :ends_at, presence: true

  def self.current(hidden_ids = nil)
    result = where("starts_at <= :now and ends_at >= :now", now: Time.zone.now)
    result = result.where("id not in (?)", hidden_ids) if hidden_ids.present?
    result
  end

  def formatted_starts_at
     self.starts_at.nil? ? " " : self.starts_at.to_s(:date_time)
  end

  def formatted_ends_at
    self.ends_at.nil? ? " " : self.ends_at.to_s(:date_time)
  end

end
