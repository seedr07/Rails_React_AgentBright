class AddLeadSourceAndTypeToLeads < ActiveRecord::Migration
  def change
    add_column :leads, :lead_source_id, :integer
    add_column :leads, :lead_type_id, :integer
  end
end
