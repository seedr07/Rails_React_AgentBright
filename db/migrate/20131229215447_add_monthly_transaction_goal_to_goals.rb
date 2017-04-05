class AddMonthlyTransactionGoalToGoals < ActiveRecord::Migration
  def change
    add_column :goals, :monthly_transaction_goal, :decimal
  end
end
