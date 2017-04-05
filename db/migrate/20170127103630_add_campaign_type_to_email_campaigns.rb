class AddCampaignTypeToEmailCampaigns < ActiveRecord::Migration[5.0]
  def change
    add_column :email_campaigns, :campaign_type, :string
  end
end
