class ChangeEmailDefaultToFalseInUsers < ActiveRecord::Migration
  def change
    change_column :users, :receive_daily_pipeline, :boolean, default: false
  end
end
