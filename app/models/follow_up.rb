class FollowUp

  def initialize(lead)
    @lead = lead
  end

  def set(number_of_hours)
    if number_of_hours > 0
      @lead.follow_up_at = Time.current + number_of_hours.to_i.hours
    end
  end

end
