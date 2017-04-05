class ChangeLeadSourceAndTypeColumnsInLeads < ActiveRecord::Migration
  def change
    rename_column :leads, :lead_type, :lead_type_old
    rename_column :leads, :lead_source, :lead_source_old
  end
end
