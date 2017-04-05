class EditFieldsInSubscriptions < ActiveRecord::Migration

  def change
    remove_column :subscriptions, :stripe_customer_id
    remove_column :subscriptions, :charge_errors_count
    remove_column :subscriptions, :state
    remove_column :subscriptions, :starts_at
    remove_column :subscriptions, :ends_at
    remove_column :subscriptions, :trial_ends_at
    remove_column :subscriptions, :last_four_digits
    remove_column :subscriptions, :card_expires_at
    remove_column :subscriptions, :subscriber_id
    remove_column :subscriptions, :subscriber_type
    remove_column :subscriptions, :stripe_subscription_id

    add_column :subscriptions, :deactivated_on, :date
    add_column :subscriptions, :scheduled_for_cancellation_on, :date
    add_column :subscriptions, :plan_type, :string, default: "StandardPlan", null: false
    add_column :subscriptions, :next_payment_amount, :decimal, default: 0.0, null: false
    add_column :subscriptions, :next_payment_on, :date
    add_column :subscriptions, :stripe_id, :string
    add_column :subscriptions, :user_id, :integer

    add_index :subscriptions, :stripe_id
    add_index :subscriptions, :user_id
  end

end
