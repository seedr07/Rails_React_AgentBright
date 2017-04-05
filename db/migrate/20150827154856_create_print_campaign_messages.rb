class CreatePrintCampaignMessages < ActiveRecord::Migration
  def change
    create_table :print_campaign_messages do |t|
      t.integer :user_id
      t.integer :contact_id
      t.integer :print_campaign_id

      t.timestamps null: false
    end
  end
end
