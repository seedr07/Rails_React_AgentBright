class AddExpiresInToAuthorizations < ActiveRecord::Migration
  def change
    add_column :authorizations, :expires_in, :integer
  end
end
