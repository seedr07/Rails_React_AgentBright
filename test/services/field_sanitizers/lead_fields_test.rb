require "test_helper"

class FieldSanitizers::LeadFieldsTest < ActiveSupport::TestCase

  def test_sanitized_params
    clean_params = FieldSanitizers::LeadFields.new(dirty_lead_params).process
    assert_equal "1000", clean_params[:additional_fees]
    assert_equal "444444444", clean_params[:contracts_attributes].first[1][:additional_fees]
    assert_equal "333333333", clean_params[:properties_attributes].first[1][:commission_fee]
  end

  private

  def dirty_lead_params
    {
      additional_fees: "1,000",
      amount_owed: "245,555",
      buyer_prequalified: "499,999",
      max_price_range: "2,500,400",
      min_price_range: "1,000,000",
      original_list_price: "999,999,999",
      prequalification_amount: "601,000",
      referral_fee_flat_fee: "234,402",
      contracts_attributes: {
        "0" => dirty_contract_params
      },
      properties_attributes: {
        "0" => dirty_property_params
      },
    }
  end

  def dirty_property_params
    {
      commission_fee: "333,333,333",
      initial_agent_valuation: "333,333,333",
      initial_client_valuation: "333,333,333",
      list_price: "333,333,333",
      original_list_price: "333,333,333",
    }
  end

  def dirty_contract_params
    {
      additional_fees: "444,444,444",
      commission_flat_fee: "444,444,444",
      offer_price: "444,444,444",
      referral_fee_flat_fee: "444,444,444",
    }
  end

end
