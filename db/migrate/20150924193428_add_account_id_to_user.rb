class AddAccountIdToUser < ActiveRecord::Migration

  def change
    add_column :users, :nylas_account_id, :string
    rename_column :users, :inbox_token, :nylas_token
  end

end
