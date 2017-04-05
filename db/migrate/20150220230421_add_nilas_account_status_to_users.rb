class AddNilasAccountStatusToUsers < ActiveRecord::Migration
  def change
    add_column :users, :nilas_account_status, :string
    add_column :users, :nilas_trial_status_set_at, :datetime
    add_column :users, :account_marked_inactive_at, :datetime
  end
end
