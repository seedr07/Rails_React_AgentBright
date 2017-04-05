class EditFieldsInPlans < ActiveRecord::Migration

  def change
    remove_column :plans, :currency
    remove_column :plans, :trial_period_days
    remove_column :plans, :stripe_id
    remove_column :plans, :published
    remove_column :plans, :statement_description
    remove_column :plans, :amount

    add_column :plans, :sku, :string, null: false
    add_column :plans, :short_description, :string, null: false
    add_column :plans, :description, :text, null: false
    add_column :plans, :active, :boolean, default: true, null: false
    add_column :plans, :price_in_dollars, :integer, null: false
    add_column :plans, :terms, :text
    add_column :plans, :featured, :boolean, default: false, null: false
    add_column :plans, :annual, :boolean, default: false
    add_column :plans, :annual_plan_id, :integer
    add_column :plans, :minimum_quantity, :integer, default: 1, null: false
    add_column :plans, :includes_team, :boolean, default: false, null: false
    add_index :plans, :annual_plan_id
  end

end
