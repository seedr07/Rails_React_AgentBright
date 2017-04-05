class RemoveNotNullUserOnContacts < ActiveRecord::Migration
  def change
    change_column_null :contacts, :user_id, true
  end
end
