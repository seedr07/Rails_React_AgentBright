class AddFieldsToContacts < ActiveRecord::Migration
  def change
    add_column :contacts, :state, :string
    add_column :contacts, :email, :string
  end
end
