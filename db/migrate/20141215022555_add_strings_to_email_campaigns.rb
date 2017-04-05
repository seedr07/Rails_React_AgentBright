class AddStringsToEmailCampaigns < ActiveRecord::Migration
  def change
    add_column :email_campaigns, :message_ids_string, :string
    add_column :email_campaigns, :contact_ids_string, :string
  end
end
