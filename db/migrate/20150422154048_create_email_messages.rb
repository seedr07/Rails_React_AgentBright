class CreateEmailMessages < ActiveRecord::Migration

  def change
    create_table :email_messages do |t|
      t.string :message_id
      t.string :thread_id
      t.string :subject
      t.string :from
      t.string :to
      t.string :cc
      t.string :bcc
      t.datetime :received_at
      t.string :snippet
      t.text :body
      t.boolean :unread
      t.string :account
      t.references :user, index: true

      t.timestamps null: false
    end
  end

end
