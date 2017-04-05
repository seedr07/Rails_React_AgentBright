class ChangeDefaultValueForForwardAfterMinutes < ActiveRecord::Migration
  def change
    change_column_default :lead_settings, :forward_after_minutes, 0
  end
end
