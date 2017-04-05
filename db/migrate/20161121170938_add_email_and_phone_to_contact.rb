class AddEmailAndPhoneToContact < ActiveRecord::Migration[5.0]

  def change
    add_column :contacts, :email, :string
    add_column :contacts, :phone_number, :string
    add_index :contacts, :email
    add_index :contacts, :phone_number

    Contact.reset_column_information
    Contact.all.each do |contact|
      contact.update_attribute :email, contact.primary_email_address&.email
      contact.update_attribute :phone_number, contact.primary_phone_number&.number
    end
  end

end
