class AddAttemptedContactAtToLeads < ActiveRecord::Migration
  def change
    add_column :leads, :attempted_contact_at, :datetime
  end
end
