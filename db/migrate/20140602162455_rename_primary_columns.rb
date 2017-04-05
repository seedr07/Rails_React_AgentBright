class RenamePrimaryColumns < ActiveRecord::Migration
  def change
    rename_column :email_addresses, :primary?, :primary
    rename_column :phone_numbers, :primary?, :primary
  end
end
