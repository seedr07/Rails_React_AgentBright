class AddSnoozedAttributesToLeads < ActiveRecord::Migration
  def change
    add_column :leads, :snoozed_at, :datetime, default: nil
    add_column :leads, :snoozed_until, :datetime, default: nil
    add_column :leads, :snoozed_by_id, :integer, default: nil
  end
end
