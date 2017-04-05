# == Schema Information
#
# Table name: market_states
#
#  abbreviation :string
#  created_at   :datetime         not null
#  id           :integer          not null, primary key
#  name         :string
#  updated_at   :datetime         not null
#

class MarketState < ActiveRecord::Base

  has_many :market_reports, as: :location
  has_many :market_cities
  has_many :market_zips
  has_many :market_counties

end
