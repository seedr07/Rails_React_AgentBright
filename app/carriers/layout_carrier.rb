class LayoutCarrier

  def env_banner
    if Rails.env.production?
      # noop
    elsif Rails.env.development?
      "dev-green-ribbon"
    else
      "staging-red-ribbon"
    end
  end

end
