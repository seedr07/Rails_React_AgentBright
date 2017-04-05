class AddLeadIdToContracts < ActiveRecord::Migration

  def change
    add_column :contracts, :lead_id, :integer

    Contract.reset_column_information

    Contract.all.each do |contract|
      lead_id = contract.property.lead_id
      contract.lead_id = lead_id

      Util.log "Contract =>  #{contract.inspect}"
      contract.save
    end
  end

end
