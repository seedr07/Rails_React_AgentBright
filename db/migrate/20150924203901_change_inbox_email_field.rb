class ChangeInboxEmailField < ActiveRecord::Migration

  def change
    rename_column :users, :email_registered_with_inbox, :nylas_connected_email_account
  end

end
