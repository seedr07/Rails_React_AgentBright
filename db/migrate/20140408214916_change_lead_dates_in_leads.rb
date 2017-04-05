class ChangeLeadDatesInLeads < ActiveRecord::Migration
  def change
    change_column :leads, :closing_date_at, :datetime
    change_column :leads, :incoming_lead_at, :datetime
  end
end
