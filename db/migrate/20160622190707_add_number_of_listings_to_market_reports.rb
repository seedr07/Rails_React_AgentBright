class AddNumberOfListingsToMarketReports < ActiveRecord::Migration[5.0]
  def change
    add_column :market_reports, :number_of_listings, :integer
  end
end
