class AddReceiveLeadsUpdateEmailToUsers < ActiveRecord::Migration
  def change
    add_column :users, :receive_daily_leads_recap_email, :boolean, default: false
  end
end
