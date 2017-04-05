class CreateLeadSettings < ActiveRecord::Migration
  def change
    create_table :lead_settings do |t|
      t.boolean :email_auto_respond, default: true
      t.string :auto_respond_subject
      t.text :auto_respond_body
      t.belongs_to :user

      t.timestamps
    end
  end
end
