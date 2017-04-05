class ChangeDefaultValueToDailyPipeline < ActiveRecord::Migration
  def change
    change_column_default :lead_settings, :daily_pipeline, true
  end
end
