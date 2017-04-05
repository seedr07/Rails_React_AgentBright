class AddFieldsToClients < ActiveRecord::Migration
  def change
    add_column :clients, :initial_property_interested_in, :string
    add_column :clients, :referring_contact, :integer
    add_column :clients, :mls_id, :string
    add_column :clients, :initial_client_valuation, :integer
    add_column :clients, :referral_fees, :integer
    add_column :clients, :timeframe, :integer
    add_column :clients, :claimed, :boolean
    add_column :clients, :property_type, :integer
    add_column :clients, :listing_address, :string
    add_column :clients, :listing_city, :string
    add_column :clients, :listing_state, :string
    add_column :clients, :listing_zip, :string
    add_column :clients, :buyer_area_of_interest, :string
  end
end
