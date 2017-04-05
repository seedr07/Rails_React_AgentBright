class AddMoreFieldsToClients < ActiveRecord::Migration
  def change
    add_column :clients, :original_list_date_at, :datetime
    add_column :clients, :original_list_price, :integer
    add_column :clients, :listing_expires_at, :datetime
    add_column :clients, :lost_date_at, :datetime
    add_column :clients, :reason_for_loss, :string
    add_column :clients, :pause_date_at, :datetime
    add_column :clients, :stage_paused, :string
    add_column :clients, :stage_lost, :string
    add_column :clients, :reason_for_pause, :string
    add_column :clients, :amount_owed, :integer
    add_column :clients, :offer_accepted_at, :datetime
    add_column :clients, :accepted_contract_price, :string
    add_column :clients, :contingencies, :string
    add_column :clients, :buyer, :string
    add_column :clients, :buyer_agent, :string
    add_column :clients, :scheduled_closing_date_at, :datetime
    add_column :clients, :estimated_gross_commission, :integer
    add_column :clients, :deal_value, :integer
    add_column :clients, :buyer_prequalified, :boolean
    add_column :clients, :prequalification_amount, :integer
    add_column :clients, :buyer_address, :string
    add_column :clients, :buyer_city, :string
    add_column :clients, :buyer_state, :string
    add_column :clients, :buyer_zip, :string
    add_column :clients, :listing_agent, :string
    add_column :clients, :seller, :string
    add_column :clients, :buyer_mls, :string
  end
end
