class RemoveSuggestedProfilePictureFromContacts < ActiveRecord::Migration
  def change
    remove_column :contacts, :suggested_profile_picture, :string
  end
end
