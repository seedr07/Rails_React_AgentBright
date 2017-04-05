class AddEmailStatusToEmailCampaigns < ActiveRecord::Migration
  def change
    add_column :email_campaigns, :email_status, :string
  end
end
