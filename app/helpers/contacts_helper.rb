module ContactsHelper

  def next_contact_date_to_s(nextdate)
    if nextdate.nil?
      "N/A"
    elsif nextdate > Time.zone.now
      cal_date(nextdate)
    else
      "ASAP"
    end
  end

  def contact_activity_status_color(contact)
    last_contacted_date = contact.last_contacted_date
    grade = contact.grade
    if grade.nil? || last_contacted_date.nil? || grade == 4
      "neutral"
    else
      acceptable_days_between_touch = Contact::CONTACT_DAYS[grade.to_i] * 2 / 3
      days_since_last_touch = (Time.zone.now.to_date - last_contacted_date.to_date).to_i.days
      if days_since_last_touch > acceptable_days_between_touch
        "danger"
      elsif days_since_last_touch > acceptable_days_between_touch * 0.75
        "warning"
      else
        "success"
      end
    end
  end

  def contact_avatar(contact)
    initials = contact.initials.upcase
    avatar_class = contact.avatar_class
    "<span class='initials-100 rounded #{avatar_class}'>
        #{initials}
      </span>"
  end

  def contact_display_name(contact)
    contact.full_name.presence ||
      display_primary_email_address(contact).presence ||
      "Unknown"
  end

  def time_since_last_contacted(contact)
    contact.last_contacted_date.nil? ? "Not yet contacted" : time_ago_in_words(contact.last_contacted_date) + " ago"
  end

  def display_contact_slats_data(contact)
    touches = contact.contact_activities.count
    if touches > 0
      '<div class="data inline-block float-left">
        <h4>' + time_since_last_contacted(contact) + '</h4>
        <p class="dim-el">Last contacted</p>
      </div><!-- /data -->'
    else
      ""
    end
  end

  def display_primary_phone_number(contact)
    if phone_number = contact.primary_phone_number
      number_to_phone(phone_number.number, area_code: true)
    else
      ""
    end
  end

  def display_primary_email_address(contact)
    if primary_email = contact.primary_email_address
      primary_email.email
    end
  end

  def basic_contact_info(contact)
    [
      display_primary_email_address(contact),
      display_primary_phone_number(contact)
    ].reject(&:blank?).join(" / ")
  end

  def lead_name(lead)
    contact = lead.contact

    contact.full_name.presence || display_primary_email_address(lead.contact).presence ||
      display_primary_phone_number(lead.contact).presence || "Unknown"
  end

  def format_phone_number(phone_number)
    formatted_phone_number = number_to_phone(phone_number.number, area_code: true)
    formatted_phone_number = "#{formatted_phone_number} (#{phone_number.number_type})"

    if phone_number.primary?
      formatted_phone_number = "#{formatted_phone_number} - <b>Primary</b>"
    end

    formatted_phone_number.html_safe
  end

  def format_email_address(email_address)
    formatted_email_address = email_address.email
    formatted_email_address = "#{formatted_email_address} (#{email_address.email_type})"

    if email_address.primary?
      formatted_email_address = "#{formatted_email_address} - <b>Primary</b>"
    end

    formatted_email_address.html_safe
  end

  def grade_popover_circle(label)
    "<span class='initials-68 circle grade'>#{label}</span>"
  end

  def grade_tooltip(grade)
    if grade == 0
      "B2B relations/multi-referrals"
    elsif grade == 1
      "Clients, Family & Friends that refer"
    elsif grade == 2
      "Folks you may have lost touch with"
    elsif grade == 3
      "Folks that may not know you're an Agent"
    elsif grade == 4
      "Exclude from Marketing - other agents/out of towners"
    else
      "Ranking Contacts helps keep in touch"
    end
  end

  def active_contacts_sorted_by_first_name(current_user)
    current_user.contacts.active.order("first_name asc")
  end

  def handle_required_validations(for_page)
    if ['lead'].include?(for_page)
      :require_base_validations
    else
      :require_basic_validations
    end
  end

end
