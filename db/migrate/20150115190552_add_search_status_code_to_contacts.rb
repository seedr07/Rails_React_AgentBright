class AddSearchStatusCodeToContacts < ActiveRecord::Migration
  def change
    add_column :contacts, :search_status_code, :integer
    add_column :contacts, :search_status_message, :string
  end
end
