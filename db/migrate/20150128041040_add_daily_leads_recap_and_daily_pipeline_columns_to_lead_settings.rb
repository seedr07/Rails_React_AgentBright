class AddDailyLeadsRecapAndDailyPipelineColumnsToLeadSettings < ActiveRecord::Migration
  def change
    add_column :lead_settings, :daily_leads_recap, :boolean, default: false
    add_column :lead_settings, :daily_pipeline, :boolean, default: false
  end
end
