class AddContactsCounterToUsers < ActiveRecord::Migration
  def change
    add_column :users, :contacts_count, :integer, default: 0

    User.reset_column_information
    User.all.each do |u|
      contact_length = u.contacts.length
      User.where(id: u.id).update_all(contacts_count: contact_length)
    end
  end
end
