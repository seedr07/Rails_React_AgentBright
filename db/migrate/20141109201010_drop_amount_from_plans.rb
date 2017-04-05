class DropAmountFromPlans < ActiveRecord::Migration
  def change
    remove_column :plans, :amount, :integer
  end
end
