class AddMessageIdToEmailCampaigns < ActiveRecord::Migration
  def change
    add_column :email_campaigns, :message_id, :string
  end
end
