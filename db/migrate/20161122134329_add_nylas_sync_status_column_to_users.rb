class AddNylasSyncStatusColumnToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :nylas_sync_status, :string
  end
end
