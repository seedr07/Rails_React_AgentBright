# == Schema Information
#
# Table name: market_reports
#
#  average_days_on_market_listings            :integer
#  average_days_on_market_sold                :integer
#  average_list_price                         :integer
#  average_sales_price                        :integer
#  created_at                                 :datetime         not null
#  id                                         :integer          not null, primary key
#  location_id                                :integer          not null
#  location_type                              :string           not null
#  median_list_price                          :integer
#  median_sales_price                         :integer
#  number_of_listings                         :integer
#  number_of_new_listings                     :integer
#  number_of_sales                            :integer
#  original_vs_sales_price_ratio_avg_for_sale :decimal(, )
#  report_date_at                             :datetime
#  updated_at                                 :datetime         not null
#
# Indexes
#
#  index_market_reports_on_location_type_and_location_id  (location_type,location_id)
#

class MarketReport < ActiveRecord::Base

  REPORT_TYPES = {
    0 => {
      field: "Active Listings, Number of",
      column: :number_of_listings
    },
    1 => {
      field: "List Price, Average",
      column: :average_list_price
    },
    2 => {
      field: "List Price, Median",
      column: :median_list_price
    },
    3 => {
      field: "CDOM, Average",
      column: :average_days_on_market_listings
    },
    4 => {
      field: "Number of New Listings",
      column: :number_of_new_listings
    },
    5 => {
      field: "Sales, Number of",
      column: :number_of_sales
    },
    6 => {
      field: "Sale Price, Average",
      column: :average_sales_price
    },
    7 => {
      field: "Sale Price, Median",
      column: :median_sales_price
    },
    8 => {
      field: "Days to Sell, Average",
      column: :average_days_on_market_sold
    },
    9 => {
      field: "Close Price to Original Price Ratio",
      column: :original_vs_sales_price_ratio_avg_for_sale
    }
  }.freeze

  belongs_to :location, polymorphic: true

  def location_name
    location.name
  end

  def sold_price_ratio_difference
    if original_vs_sales_price_ratio_avg_for_sale
      original_vs_sales_price_ratio_avg_for_sale - 100
    end
  end

  def sold_price_ratio_difference_word
    if sold_price_ratio_difference > 0
      "above"
    else
      "below"
    end
  end

end
