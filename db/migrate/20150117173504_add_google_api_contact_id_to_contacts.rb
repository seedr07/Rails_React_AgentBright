class AddGoogleApiContactIdToContacts < ActiveRecord::Migration
  def change
    add_column :contacts, :google_api_contact_id, :string
  end
end
