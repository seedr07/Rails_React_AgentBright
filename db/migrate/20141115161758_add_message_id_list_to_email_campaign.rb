class AddMessageIdListToEmailCampaign < ActiveRecord::Migration
  def change
    add_column :email_campaigns, :message_id_list, :string, array: true, default: []
    add_column :email_campaigns, :contact_list, :integer, array: true, default: []
  end
end
