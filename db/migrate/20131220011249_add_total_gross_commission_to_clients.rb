class AddTotalGrossCommissionToClients < ActiveRecord::Migration
  def change
    add_column :clients, :total_gross_commission, :integer
  end
end
