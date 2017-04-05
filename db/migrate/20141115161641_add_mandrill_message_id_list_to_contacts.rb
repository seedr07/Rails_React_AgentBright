class AddMandrillMessageIdListToContacts < ActiveRecord::Migration
  def change
    add_column :contacts, :mandrill_message_id_list, :string, array: true, default: []
  end
end
