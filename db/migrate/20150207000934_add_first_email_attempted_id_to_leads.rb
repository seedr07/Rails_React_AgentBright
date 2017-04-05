class AddFirstEmailAttemptedIdToLeads < ActiveRecord::Migration
  def change
    add_column :leads, :first_email_attempted_id, :integer
  end
end
