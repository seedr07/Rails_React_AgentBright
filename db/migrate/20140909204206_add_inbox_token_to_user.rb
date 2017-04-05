class AddInboxTokenToUser < ActiveRecord::Migration
  
  def change
    add_column :users, :inbox_token, :string
  end

end
