class CreateEmailAddresses < ActiveRecord::Migration
  def change
    create_table :email_addresses do |t|
      t.references :owner, polymorphic: true
      t.string :email
      t.string :email_type
      t.boolean :primary?

      t.timestamps
    end
  end
end
