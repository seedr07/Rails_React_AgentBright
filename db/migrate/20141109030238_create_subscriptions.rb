class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.string :stripe_customer_id, null: false, index: true
      t.integer :charge_errors_count, null: false, default: 0
      t.string :state, null: false, default: 'pending', index: true
      t.datetime :starts_at
      t.datetime :ends_at
      t.datetime :trial_ends_at
      t.integer :account_balance
      t.string :last_four_digits
      t.datetime :card_expires_at
      t.references :subscriber, index: true, polymorphic: true, null: false
      t.references :plan, index: true, null: false

      t.timestamps
    end
  end
end
