class AddColumnOnUsersReceiveDailyPipeline < ActiveRecord::Migration
  def change
    add_column :users, :receive_daily_pipeline, :boolean, :default => true
  end
end
