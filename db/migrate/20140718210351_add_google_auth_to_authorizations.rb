class AddGoogleAuthToAuthorizations < ActiveRecord::Migration
  
  def change
    add_column :authorizations, :refresh_token, :string
    add_column :authorizations, :refresh_expires, :boolean
    add_column :authorizations, :refresh_token_expires_at, :datetime
  end

end