class LeadContactedStatusUpdater

  attr_accessor :lead

  def initialize(lead)
    @lead = lead
  end

  def set_as_attempted_contact
    @lead.contacted_status = 1
    @lead.attempted_contact_at = Time.current
  end

  def set_as_awaiting_reply
    @lead.contacted_status = 2
    @lead.attempted_contact_at = Time.current
  end

  def set_as_contacted(status=nil)
    if status
      status == 8 ? status = 1 : status
      @lead.contacted_status = 3
      @lead.status = Lead::STATUSES[status][1]
    else
      @lead.contacted_status = 3
    end
  end

end
