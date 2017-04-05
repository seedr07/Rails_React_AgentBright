class CreateInboxMessages < ActiveRecord::Migration

  def change
    create_table :inbox_messages do |t|
      t.string :opens_tracking_id
      t.string :clicks_tracking_id
      t.string :inbox_message_id
      t.boolean :opened
      t.boolean :clicked
      t.string :sent_to_email_address
      t.references :user, index: true
      t.references :lead, index: true
      t.references :contact, index: true

      t.timestamps
    end
  end

end
