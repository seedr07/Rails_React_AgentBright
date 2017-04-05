class ChangeDefaultValueToDailyLeadsRecap < ActiveRecord::Migration
  def change
    change_column_default :lead_settings, :daily_leads_recap, true
  end
end
