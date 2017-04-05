class FieldSanitizers::FieldCleaner

  include Sanitizer

  attr_accessor :params
  attr_reader :cleanable_fields

  def initialize(params:, cleanable_fields:nil)
    @params = params
    @cleanable_fields = cleanable_fields
  end

  def scrub
    if params_and_cleanable_fields_present?
      @cleanable_fields.each do |field|
        sanitize_field(field)
      end
    end

    params
  end

  def scrub_property_fields
    @cleanable_fields = property_price_fields
    scrub
  end

  private

  def params_and_cleanable_fields_present?
    params && cleanable_fields
  end

  def sanitize_field(field)
    if params[field].present?
      params[field] = sanitize_price(params[field])
    end
  end

end
