class AddEmailAddressesToEmailMessages < ActiveRecord::Migration[5.0]
  def change
    add_column :email_messages, :to_email_addresses, :string, array: true, default: []
  end
end
