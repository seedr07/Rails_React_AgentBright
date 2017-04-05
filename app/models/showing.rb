# == Schema Information
#
# Table name: showings
#
#  address1               :string
#  city                   :string
#  comments               :text
#  confirmed              :boolean
#  created_at             :datetime
#  date_time              :datetime
#  email_request_to_agent :boolean
#  id                     :integer          not null, primary key
#  lead_id                :integer
#  list_price             :decimal(, )
#  listing_agent          :string
#  mls_number             :string
#  requested              :boolean
#  state                  :string
#  status                 :integer
#  updated_at             :datetime
#  zip                    :string
#

class Showing < ActiveRecord::Base

	belongs_to :lead

	SHOWING_STATUS = [["Request", 0], ["Scheduled",1], ["Confirmed",2], ["Pending ",3]]

  def status_to_s
  	status.nil? ? "N/A" :SHOWING_STATUS[status][0]
  end

  def date_time_format
  	self.date_time.nil? ? " " :date_time.to_s(:date_time)
  end

end
