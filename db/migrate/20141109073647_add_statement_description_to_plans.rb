class AddStatementDescriptionToPlans < ActiveRecord::Migration
  def change
    add_column :plans, :statement_description, :string, default: "Charge on #{Time.zone.now}"
  end
end
