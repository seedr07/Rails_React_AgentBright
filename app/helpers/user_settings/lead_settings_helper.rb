module UserSettings::LeadSettingsHelper

  def display_auto_respond_status view_service
    if view_service.email_auto_respond_status_on?
      "<span class='label label-success'> #{view_service.auto_respond_status_text} </span>"
    else
      "<span class='label label-warning'> #{view_service.auto_respond_status_text} </span>"
    end
  end

  def display_auto_lead_forward_status view_service
    if view_service.email_auto_lead_forward_status_on?
      "<span class='label label-success'> #{view_service.auto_lead_forward_status_text} </span>"
    else
      "<span class='label label-warning'> #{view_service.auto_lead_forward_status_text} </span>"
    end
  end

  def display_auto_lead_broadcast_status view_service
    if view_service.email_auto_lead_broadcast_status_on?
      "<span class='label label-success'> #{view_service.auto_lead_broadcast_status_text} </span>"
    else
      "<span class='label label-warning'> #{view_service.auto_lead_broadcast_status_text} </span>"
    end
  end

  def display_lead_source_status_icon parsing_from_source_active
    if parsing_from_source_active
      '<span class="indicator-lg indicator-good"><span class="fui-check"></span></span>'
    else
      '<span class="indicator-lg indicator-bad"><span class="fui-cross"></span></span>'
    end
  end

end
