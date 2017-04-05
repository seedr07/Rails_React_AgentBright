class AddTextAttributesToEmailCampaigns < ActiveRecord::Migration
  def change
    add_column :email_campaigns, :contacts, :text
    add_column :email_campaigns, :groups, :text
  end
end
