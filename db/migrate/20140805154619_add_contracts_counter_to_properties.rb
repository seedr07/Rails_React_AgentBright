class AddContractsCounterToProperties < ActiveRecord::Migration

  def change
    add_column :properties, :contracts_count, :integer, :default => 0

    Property.reset_column_information
    Property.all.each do |property|
      contract_length = property.contracts.length
      Property.where(id: property.id).update_all(contracts_count: contract_length)
    end
  end

end
