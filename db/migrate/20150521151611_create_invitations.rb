class CreateInvitations < ActiveRecord::Migration

  def change
    create_table :invitations do |t|
      t.references :team, index: true, foreign_key: true, null: false
      t.string :email, null: false
      t.string :code, null: false
      t.datetime :accepted_at
      t.integer :sender_id, null: false
      t.integer :recipient_id

      t.timestamps null: false
    end
    add_index :invitations, :code
  end

end
