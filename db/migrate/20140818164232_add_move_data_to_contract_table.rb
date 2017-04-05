class AddMoveDataToContractTable < ActiveRecord::Migration
  
  def change
    
    Lead.reset_column_information

    Lead.all.each do |lead|
      if lead.status == 3
        contract_status = "Pending"
      elsif lead.status == 4
        contract_status = "Closed"
      end
      if lead.client_type == "Seller" && (lead.status == 3 || lead.status == 4)
        if lead.accepted_listing_contract.nil?
          contract = lead.contracts.build property: lead.listing_property,
                        offer_price: lead.accepted_contract_price,
                        closing_price: lead.closing_price,
                        offer_accepted_date_at: lead.offer_accepted_at,
                        buyer: lead.buyer,
                        buyer_agent: lead.buyer_agent,
                        commission_type: "Percentage",
                        commission_rate: lead.contract_commission_rate,
                        contract_type: "Seller",
                        status: contract_status

          if lead.contingencies.present?
            comment = lead.comments.build user: lead.user,
                          content: "Contingencies: #{lead.contingencies}"
          end
        end

        Util.log "Lead =>   #{lead.inspect}"
        Util.log "Contract =>    #{contract.inspect}"
        lead.save
      end

      if lead.client_type == "Buyer"
        if lead.status == 3 || lead.status == 4
          if lead.accepted_buyer_contract.nil?
            contract = lead.contracts.build contract_type: "Buyer",
                          property: lead.properties.first,
                          offer_price: lead.accepted_contract_price,
                          closing_price: lead.closing_price,
                          offer_accepted_date_at: lead.offer_accepted_at,
                          seller: lead.seller,
                          seller_agent: lead.listing_agent,
                          commission_type: "Percentage",
                          commission_rate: lead.contract_commission_rate,
                          status: contract_status

            if lead.contingencies.present?
              comment = lead.comments.build user: lead.user,
                            content: "Contingencies: #{lead.contingencies}"
            end
          end

          Util.log "Lead =>    #{lead.inspect}"
          Util.log "Contract =>     #{contract.inspect}"
          lead.save
        end
      end
    end

  end

end
