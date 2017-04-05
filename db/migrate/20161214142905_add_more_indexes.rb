class AddMoreIndexes < ActiveRecord::Migration[5.0]
  def change
    # These indexes added mostly for CSV importing purpose.
    add_index :contacts, [:user_id, :active, :grade]

    remove_index :phone_numbers, [:owner_type, :owner_id]
    add_index :phone_numbers, [:owner_id, :owner_type]
    add_index :phone_numbers, [:owner_id, :owner_type, :number]
    add_index :phone_numbers, [:owner_id, :owner_type, :primary]
    add_index :phone_numbers, [:owner_type, :number]
    add_index :phone_numbers, [:owner_id, :owner_type, :number, :primary], name: "phone_numbers_powerful_index"

    remove_index :email_addresses, [:owner_type, :owner_id]
    add_index :email_addresses, [:owner_id, :owner_type]
    add_index :email_addresses, [:owner_id, :owner_type, :email]
    add_index :email_addresses, [:owner_id, :owner_type, :primary]
    add_index :email_addresses, [:owner_type, :email, :primary]
    add_index :email_addresses, [:owner_id, :owner_type, :email, :primary], name: "email_addresses_powerful_index"
  end
end
