class ChangeInboxTokenToBeFalseByDefaultInUsers < ActiveRecord::Migration
  def change
    def change
      change_column :users, :inbox_token, :boolean, default: false, null: false
    end
  end
end
