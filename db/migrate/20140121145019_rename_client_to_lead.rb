class RenameClientToLead < ActiveRecord::Migration
  def change
    rename_table :clients, :leads
  end
end
