class AddYahooContactIdToContacts < ActiveRecord::Migration
  def change
    add_column :contacts, :yahoo_contact_id, :string
  end
end
