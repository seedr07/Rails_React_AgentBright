class CreateCheckouts < ActiveRecord::Migration

  def change
    create_table :checkouts do |t|
      t.references :user, index: true, foreign_key: true, null: false
      t.references :plan, index: true, foreign_key: true, null: false
      t.string :stripe_coupon_id

      t.timestamps null: false
    end
  end

end
