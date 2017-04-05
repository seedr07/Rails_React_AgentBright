class AddInboxEmailToUser < ActiveRecord::Migration
  
  def change
    add_column :users, :email_registered_with_inbox, :string
  end

end
