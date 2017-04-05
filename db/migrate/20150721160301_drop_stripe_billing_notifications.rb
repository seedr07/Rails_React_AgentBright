class DropStripeBillingNotifications < ActiveRecord::Migration

  def change
    drop_table :stripe_billing_notifications
  end

end
