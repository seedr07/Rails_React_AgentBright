class AddNilasCalendarSettingIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :nilas_calendar_setting_id, :string
  end
end
