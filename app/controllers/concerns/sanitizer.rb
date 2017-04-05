module Sanitizer

  private

  def sanitize_price(price_value)
    price_value.gsub(",", "")
  end

  def lead_price_fields
    [
      :additional_fees,
      :amount_owed,
      :buyer_prequalified,
      :max_price_range,
      :min_price_range,
      :original_list_price,
      :prequalification_amount,
      :referral_fee_flat_fee,
    ]
  end

  def property_price_fields
    [
      :commission_fee,
      :initial_agent_valuation,
      :initial_client_valuation,
      :list_price,
      :original_list_price,
    ]
  end

  def contract_price_fields
    [
      :additional_fees,
      :commission_flat_fee,
      :offer_price,
      :referral_fee_flat_fee,
    ]
  end
end
