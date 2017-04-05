class CommissionCarrier

  # Why we should use carrier, please check this
  # http://blog.bigbinary.com/2014/12/02/drying-up-rails-views-with-view-carriers-and-services.html

  attr_reader :user

  def initialize(user)
    @user = user
  end

  def handle_active_class(attribute, compare_with)
    if fetch_value_for(attribute) == compare_with
      "active"
    else
      ""
    end
  end

  def handle_display_block_class(attribute, compare_with)
    if fetch_value_for(attribute) == compare_with
      "block"
    else
      "none"
    end
  end

  def data_attribute_for_agent_split(hash, controller_name)
    # Needs to handle this data attribute, because some javascript functions are
    # depedended on this. Goals related javascripts try to find this data attribute.

    if controller_name == "goals"
      hash["goal-param"] =  "agent_split"
    end

    hash
  end

  def handle_display_if_attribute_nil(attribute)
    if fetch_value_for(attribute).blank?
      "none"
    else
      "block"
    end
  end

  private

  def fetch_value_for(attribute)
    user.public_send(attribute.to_sym)
  end

end
