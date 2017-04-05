class CreateAuthorizations < ActiveRecord::Migration
  def change
    create_table :authorizations do |t|
      t.string :provider
      t.string :uid
      t.references :user, index: true
      t.string :token
      t.string :secret
      t.string :first_name
      t.string :last_name
      t.string :name
      t.string :link

      t.timestamps
    end
  end
end
