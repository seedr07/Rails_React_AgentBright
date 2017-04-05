class AddOriginalListPriceDateToLeads < ActiveRecord::Migration
  
  def change
    add_column :leads, :original_list_date_at, :datetime
    add_column :leads, :original_list_price, :decimal

    Lead.reset_column_information

    Lead.all.each do |lead|
      if lead.client_type == "Seller"
        if property = lead.listing_property
          lead.original_list_date_at = property.original_list_date_at
          lead.original_list_price = property.original_list_price
        end

        Util.log "Property =>      #{lead.listing_property}"
        Util.log "Lead =>     #{lead.inspect}"
        lead.save
      end

    end

  end

end
