class CreateContracts < ActiveRecord::Migration
  def change
    create_table :contracts do |t|
      t.references :property, index: true
      t.decimal :offer_price
      t.decimal :closing_price
      t.datetime :offer_accepted_date_at
      t.datetime :closing_date_at

      t.timestamps
    end
  end
end
