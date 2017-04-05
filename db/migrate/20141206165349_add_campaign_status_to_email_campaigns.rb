class AddCampaignStatusToEmailCampaigns < ActiveRecord::Migration
  def change
    add_column :email_campaigns, :campaign_status, :integer, default: 0
  end
end
