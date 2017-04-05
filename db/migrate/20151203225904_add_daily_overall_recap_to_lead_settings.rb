class AddDailyOverallRecapToLeadSettings < ActiveRecord::Migration
  def change
    add_column :lead_settings, :daily_overall_recap, :boolean, :default => true
  end
end
