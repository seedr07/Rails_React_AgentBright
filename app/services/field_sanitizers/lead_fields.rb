class FieldSanitizers::LeadFields

  include Sanitizer

  attr_accessor :lead_params

  def initialize(lead_params)
    @lead_params = lead_params
  end

  def process
    clean_lead_price_fields
    clean_each_property
    clean_each_contract

    @lead_params
  end

  private

  def clean_lead_price_fields
    FieldSanitizers::FieldCleaner.
      new(params: @lead_params, cleanable_fields: lead_price_fields).
      scrub
  end

  def clean_each_property
    if property_attributes_present?
      @lead_params[:properties_attributes].each do |index, property|
        if property.present?
          clean_property_price_fields(property)
        end
        @lead_params[:properties_attributes][index] = property
      end
    end
  end

  def clean_each_contract
    if contract_attributes_present?
      @lead_params[:contracts_attributes].each do |index, contract|
        if contract.present?
          clean_contract_price_fields(contract)
        end
        @lead_params[:contracts_attributes][index] = contract
      end
    end
  end

  def property_attributes_present?
    @lead_params[:properties_attributes].present?
  end

  def clean_property_price_fields(property)
    FieldSanitizers::FieldCleaner.
      new(params: property, cleanable_fields: property_price_fields).
      scrub
  end

  def contract_attributes_present?
    @lead_params[:contracts_attributes].present?
  end

  def clean_contract_price_fields(contract)
    FieldSanitizers::FieldCleaner.
      new(params: contract, cleanable_fields: contract_price_fields).
      scrub
  end

end
