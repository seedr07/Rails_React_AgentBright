class AddPriceRangeToClients < ActiveRecord::Migration
  def change
    add_column :clients, :min_price_range, :integer
    add_column :clients, :max_price_range, :integer
  end
end
