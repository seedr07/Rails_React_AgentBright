class CreateMarketCities < ActiveRecord::Migration
  def change
    create_table :market_cities do |t|
      t.string :name
      t.integer :market_county_id
      t.integer :market_state_id

      t.timestamps null: false
    end
  end
end
