class ChangeColumnName < ActiveRecord::Migration
  def change
     rename_column :leads, :referring_contact, :referring_contact_id

  end
end
