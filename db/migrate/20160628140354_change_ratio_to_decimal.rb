class ChangeRatioToDecimal < ActiveRecord::Migration[5.0]

  def change
    change_column :market_reports, :original_vs_sales_price_ratio_avg_for_sale, :decimal
  end

end
