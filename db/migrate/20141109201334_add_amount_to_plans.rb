class AddAmountToPlans < ActiveRecord::Migration
  def change
    add_column :plans, :amount, :float
  end
end
