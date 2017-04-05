class CreateStripeBillingNotifications < ActiveRecord::Migration
  def change
    create_table :stripe_billing_notifications do |t|
      t.string :message
      t.boolean :read, default: false
      t.string :stripe_event
      t.references :user, index: true

      t.timestamps
    end
  end
end
