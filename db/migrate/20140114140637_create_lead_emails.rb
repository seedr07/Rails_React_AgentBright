class CreateLeadEmails < ActiveRecord::Migration
  def change
    create_table :lead_emails do |t|
      t.string :recipient
      t.string :to
      t.string :from
      t.string :subject
      t.string :date
      t.string :token, unique: true
      t.text :text
      t.text :html
      t.text :headers
      t.timestamps
    end

    add_index :lead_emails, :recipient
  end
end
