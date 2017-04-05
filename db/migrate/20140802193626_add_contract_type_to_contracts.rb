class AddContractTypeToContracts < ActiveRecord::Migration
  def change
    add_column :contracts, :contract_type, :string
  end
end
