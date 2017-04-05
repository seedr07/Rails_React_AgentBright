class AddLeadStatusToLeads < ActiveRecord::Migration
  def change
    add_column :leads, :contacted_status, :string, default: "not_contacted"
  end
end
