class AddFieldsToAuthorizations < ActiveRecord::Migration
  def change
    add_column :authorizations, :email, :string
    add_column :authorizations, :access_token, :string
  end
end
