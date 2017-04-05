class CreateMarketReports < ActiveRecord::Migration
  def change
    create_table :market_reports do |t|
      t.references :location, index: true, polymorphic: true, null: false
      t.datetime :report_date_at
      t.integer :average_list_price
      t.integer :median_list_price
      t.integer :average_days_on_market_listings
      t.integer :number_of_new_listings
      t.integer :number_of_sales
      t.integer :average_sales_price
      t.integer :median_sales_price
      t.integer :average_days_on_market_sold
      t.integer :original_vs_sales_price_ratio_avg_for_sale

      t.timestamps null: false
    end
  end
end
