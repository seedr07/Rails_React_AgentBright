class AddLongTermProspectReasonToLead < ActiveRecord::Migration
  def change
    add_column :leads, :reason_for_long_term_prospect, :string
  end
end
