# == Schema Information
#
# Table name: market_cities
#
#  created_at       :datetime         not null
#  id               :integer          not null, primary key
#  market_county_id :integer
#  market_state_id  :integer
#  name             :string
#  updated_at       :datetime         not null
#

class MarketCity < ActiveRecord::Base

  belongs_to :market_county
  belongs_to :market_state
  has_many :market_reports, as: :location
  has_many :market_zips

  AREAS = JSON.parse(File.read(Rails.root.join("config/csv/locations/areas.json"))).freeze

end
