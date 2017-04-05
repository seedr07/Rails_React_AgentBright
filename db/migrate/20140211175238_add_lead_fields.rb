class AddLeadFields < ActiveRecord::Migration
  def change
    add_column :leads, :state, :string, dafault: "new_lead"
    add_column :leads, :created_by_user_id, :integer
  end
end
