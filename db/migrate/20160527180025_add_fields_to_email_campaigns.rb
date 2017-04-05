class AddFieldsToEmailCampaigns < ActiveRecord::Migration
  def change
    add_column :email_campaigns, :track_opens, :boolean, default: true
    add_column :email_campaigns, :track_clicks, :boolean, default: true
    add_column :email_campaigns, :send_generic_report, :boolean, default: true
    add_column :email_campaigns, :custom_delivery_time, :boolean, default: false
    add_column :email_campaigns, :color_scheme, :string
    add_column :email_campaigns, :custom_message, :text
    add_column :email_campaigns, :display_custom_message, :boolean, default: false
  end
end
