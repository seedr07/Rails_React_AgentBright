class RemoveReceiveDailyPipelineAndReceiveDailyLeadsRecapEmailColumnsFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :receive_daily_pipeline
    remove_column :users, :receive_daily_leads_recap_email
  end
end
