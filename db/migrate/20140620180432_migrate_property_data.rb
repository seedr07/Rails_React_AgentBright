class MigratePropertyData < ActiveRecord::Migration
  
  def change
    add_column :properties, :transaction_type, :string
    add_column :properties, :initial_property_interested_in, :boolean, 
      default: false

    Lead.reset_column_information

    Lead.all.each do |lead|
      if lead.client_type == "Seller"
        property = lead.properties.build transaction_type: "Seller",
                      list_price: lead.current_price,
                      original_list_date_at: lead.original_list_date_at,
                      original_list_price: lead.original_list_price,
                      listing_expires_at: lead.listing_expires_at,
                      mls_number: lead.mls_id,
                      property_url: lead.incoming_lead_url,
                      commission_type: "Commission",
                      commission_percentage: lead.agent_commission_percentage,
                      initial_agent_valuation: lead.initial_agent_valuation,
                      initial_client_valuation: lead.initial_client_valuation,
                      property_type: lead.property_type

        property.address.build street: lead.listing_address,
                      city: lead.listing_city,
                      state: lead.listing_state,
                      zip: lead.listing_zip

        Util.log "Lead =>  #{lead.inspect}"
        Util.log "Property =>  #{lead.properties.inspect}"
        lead.save
      elsif lead.client_type == "Buyer"
        property = lead.properties.build transaction_type: "Buyer",
                      commission_type: "Commission",
                      commission_percentage: lead.contract_commission_rate,
                      property_type: lead.property_type,
                      list_price: lead.accepted_contract_price

        property.address.build street: lead.buyer_address,
                      city: lead.buyer_city,
                      state: lead.buyer_state,
                      zip: lead.buyer_zip
        if lead.buyer_address == lead.incoming_lead_address && lead.buyer_city == lead.incoming_lead_city
          property.initial_property_interested_in = true
        else
          lead_property = lead.properties.build transaction_type: "Buyer",
                                  mls_number: lead.incoming_lead_mls,
                                  property_url: lead.incoming_lead_url,
                                  list_price: lead.incoming_lead_price,
                                  notes: lead.incoming_lead_message,
                                  initial_property_interested_in: true

          lead_property.address.build street: lead.incoming_lead_address,
                                  city: lead.incoming_lead_city,
                                  state: lead.incoming_lead_state,
                                  zip: lead.incoming_lead_zip
        end
        Util.log "Lead =>  #{lead.inspect}"
        Util.log "Property =>  #{lead.properties.inspect}"
        lead.save
      end
    end
  end

end
