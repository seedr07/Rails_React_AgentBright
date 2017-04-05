class CreateMarketCounties < ActiveRecord::Migration
  def change
    create_table :market_counties do |t|
      t.string :name
      t.integer :market_state_id

      t.timestamps null: false
    end
  end
end
