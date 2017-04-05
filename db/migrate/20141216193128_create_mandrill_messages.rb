class CreateMandrillMessages < ActiveRecord::Migration
  def change
    create_table :mandrill_messages do |t|
      t.string :mandrill_id
      t.references :user, index: true
      t.references :contact, index: true
      t.references :email_campaign, index: true

      t.timestamps
    end
  end
end
