# == Schema Information
#
# Table name: market_counties
#
#  created_at      :datetime         not null
#  id              :integer          not null, primary key
#  market_state_id :integer
#  name            :string
#  updated_at      :datetime         not null
#

class MarketCounty < ActiveRecord::Base

  belongs_to :market_state
  has_many :market_cities
  has_many :market_reports, as: :location
  has_many :market_zips

end
