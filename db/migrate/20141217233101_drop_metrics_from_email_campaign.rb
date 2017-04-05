class DropMetricsFromEmailCampaign < ActiveRecord::Migration
  def change
    remove_column :email_campaigns, :last_clicked, :datetime
    remove_column :email_campaigns, :last_opened, :datetime
    add_column :email_campaigns, :last_opened, :integer, default: 0
    add_column :email_campaigns, :last_clicked, :integer, default: 0
  end
end
