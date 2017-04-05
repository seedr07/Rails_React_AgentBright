class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.string :name, null: false
      t.integer :amount, null: false
      t.string :interval, null: false, default: 'month'
      t.string :currency, null: false, default: 'usd'
      t.text :description
      t.integer :trial_period_days, default: 7
      t.string :stripe_id, null: false, default: ""
      t.boolean :published, null: false, default: true

      t.timestamps
    end
  end
end
