class RemoveStringsFromEmailCampaigns < ActiveRecord::Migration
  def change
    remove_column :email_campaigns, :contacts, :string
    remove_column :email_campaigns, :groups, :string
  end
end
