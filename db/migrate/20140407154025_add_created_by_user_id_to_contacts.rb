class AddCreatedByUserIdToContacts < ActiveRecord::Migration
  def change
    add_column :contacts, :created_by_user_id, :integer
  end
end
