class AddSpouseLastNameToContacts < ActiveRecord::Migration
  def change
    add_column :contacts, :spouse_last_name, :string
  end
end
