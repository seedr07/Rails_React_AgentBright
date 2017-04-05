class AddNameToEmailCampaigns < ActiveRecord::Migration
  def change
    add_column :email_campaigns, :name, :string
  end
end
