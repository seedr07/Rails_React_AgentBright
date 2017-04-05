class AddGroupsToEmailCampaigns < ActiveRecord::Migration
  def change
    add_column :email_campaigns, :groups, :string, default: ""
  end
end
