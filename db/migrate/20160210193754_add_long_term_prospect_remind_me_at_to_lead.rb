class AddLongTermProspectRemindMeAtToLead < ActiveRecord::Migration
  def change
    add_column :leads, :long_term_prospect_remind_me_at, :datetime
  end
end
