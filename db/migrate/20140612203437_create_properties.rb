class CreateProperties < ActiveRecord::Migration
  def change
    create_table :properties do |t|
      t.references :lead, index: true
      t.references :user, index: true
      t.decimal :list_price
      t.string :mls_number
      t.string :property_url
      t.string :property_type
      t.boolean :rental
      t.datetime :original_list_date_at
      t.decimal :original_list_price
      t.datetime :listing_expires_at
      t.string :commission_type
      t.decimal :commission_percentage
      t.decimal :commission_fee
      t.decimal :referral_fees
      t.decimal :additional_fees
      t.decimal :initial_client_valuation
      t.decimal :initial_agent_valuation
      t.integer :bedrooms
      t.decimal :bathrooms
      t.integer :sq_feet
      t.decimal :lot_size
      t.text :notes

      t.timestamps
    end
  end
end
