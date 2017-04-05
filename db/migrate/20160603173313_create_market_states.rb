class CreateMarketStates < ActiveRecord::Migration
  def change
    create_table :market_states do |t|
      t.string :name
      t.string :abbreviation

      t.timestamps null: false
    end
  end
end
