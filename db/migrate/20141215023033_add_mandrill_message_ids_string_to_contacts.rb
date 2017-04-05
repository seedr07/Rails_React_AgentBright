class AddMandrillMessageIdsStringToContacts < ActiveRecord::Migration
  def change
    add_column :contacts, :mandrill_message_ids_string, :string
  end
end
