class AddSearchStatusToContacts < ActiveRecord::Migration
  def change
    add_column :contacts, :search_status, :string
  end
end
