class AddNewColumnsToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :email_signature, :text
    add_column :users, :email_signature_status, :boolean
  end
end
