class RenameUsersPhoneNumberToMobileNumber < ActiveRecord::Migration
  def change
    rename_column :users, :phone_number, :mobile_number
  end
end
