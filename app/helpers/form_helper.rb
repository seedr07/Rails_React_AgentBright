module FormHelper

  def setup_property(property)
    property.address ||= Address.new
    property
  end

  def setup_lead(lead)
    lead.properties ||= Property.new
    lead
  end

end