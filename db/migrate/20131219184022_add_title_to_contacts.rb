class AddTitleToContacts < ActiveRecord::Migration
  def change
    add_column :contacts, :title, :string
  end
end
