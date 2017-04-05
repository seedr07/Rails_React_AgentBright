class CreateStripeWebhooks < ActiveRecord::Migration
  def change
    create_table :stripe_webhooks do |t|
      t.string :event_type
      t.integer :amount
      t.string :info
      t.string :customer_id
      t.integer :ts
      t.references :user, index: true
      t.timestamps
    end
  end
end
