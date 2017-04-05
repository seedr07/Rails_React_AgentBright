class AddOpensAndClicksTrackingColumnsToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :email_campaign_track_opens, :boolean, default: true
    add_column :users, :email_campaign_track_clicks, :boolean, default: true
  end
end
