class AddMetricsToEmailCampaigns < ActiveRecord::Migration
  def change
    add_column :email_campaigns, :unique_clicks, :integer, default: 0
    add_column :email_campaigns, :unique_opens, :integer, default: 0
    add_column :email_campaigns, :total_clicks, :integer, default: 0
    add_column :email_campaigns, :total_opens, :integer, default: 0
    add_column :email_campaigns, :last_opened, :datetime
    add_column :email_campaigns, :last_clicked, :datetime
    add_column :email_campaigns, :successful_deliveries, :integer, default: 0
  end
end
