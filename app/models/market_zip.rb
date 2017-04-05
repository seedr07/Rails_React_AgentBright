# == Schema Information
#
# Table name: market_zips
#
#  created_at       :datetime         not null
#  id               :integer          not null, primary key
#  market_city_id   :integer
#  market_county_id :integer
#  market_state_id  :integer
#  name             :string
#  updated_at       :datetime         not null
#

class MarketZip < ActiveRecord::Base

  belongs_to :market_city
  belongs_to :market_county
  belongs_to :market_state
  has_many :market_reports, as: :location

end
