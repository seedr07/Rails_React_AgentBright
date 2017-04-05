module DatetimeFormattingHelper

  def cal_date(date)
    date.nil? ? "None" : date.to_date.to_s(:cal_date)
  end

  def datetime_to_s(datetime)
    datetime.nil? ? "None" : datetime.to_s(:tiny_datetime)
  end

  def standard_date(date)
    date.nil? ? "" : date.to_date.to_s(:std_date)
  end

  def format_for_datepicker(date)
    if browser.device.mobile?
      logger.debug "on mobile devide"
      date.nil? ? "" : date.to_date.to_s(:month_day_comma_year)
    else
      logger.debug "on desktop"
      date.nil? ? "" : date.to_date.to_s(:std_date)
    end
  end

  def short_date(date)
    date.nil? ? "-" : date.to_date.to_s(:short_date)
  end

  def tiny_date(date)
    date.nil? ? "-" : date.to_date.to_s(:tiny_date)
  end

  def just_time(datetime)
    datetime.nil? ? "" : datetime.strftime("%l:%M%p")
  end

  def datetime_no_year(datetime)
    datetime.nil? ? "" : datetime.to_s(:no_year)
  end

  def long_day_date(datetime)
    datetime.nil? ? "" : datetime.to_date.to_s(:long_day_date)
  end

  def display_time_ago(datetime)
    return if datetime.nil?

    now = Time.zone.now
    if datetime > now
      "in #{time_ago_in_words(datetime)}"
    elsif datetime > now.beginning_of_day
      "#{time_ago_in_words(datetime)} ago"
    elsif datetime > now.beginning_of_day - 1.day
      "Yesterday at #{datetime.strftime('%I:%M%p')}"
    elsif datetime > now.beginning_of_week(:sunday)
      "#{datetime.strftime('%A')} at #{datetime.strftime('%I:%M%p')}"
    elsif datetime > now.beginning_of_year
      "on #{datetime.strftime('%b %e')}"
    else
      "on #{datetime.strftime('%b %e, %Y')}"
    end
  end

  def display_date_ago(datetime)
    now = Time.zone.now
    if datetime
      if datetime >= now.end_of_week(:sunday) + 14.days
        "on #{datetime.strftime('%b %e')}"
      elsif datetime >= now.end_of_week(:sunday) + 7.days
        "next #{datetime.strftime('%A')}"
      elsif datetime >= now.end_of_week(:sunday)
        "#{datetime.strftime('%A')}"
      elsif datetime >= now.beginning_of_day + 1.day
        "Tomorrow"
      elsif datetime >= now.beginning_of_day
        "Today"
      elsif datetime >= now.beginning_of_day - 1.day
        "Yesterday"
      elsif datetime >= now.beginning_of_week(:sunday)
        "#{datetime.strftime('%A')}"
      elsif datetime >= now.beginning_of_year
        "on #{datetime.strftime('%b %e')}"
      else
        "on #{datetime.strftime('%b %e, %Y')}"
      end
    else
      ""
    end
  end

  def display_quick_datetime(datetime)
    now = Time.zone.now
    if datetime
      if datetime > now
        "#{datetime.strftime('%b %e')}"
      elsif datetime > now.beginning_of_day
        "#{datetime.strftime('%I:%M%p')}"
      elsif datetime > now.beginning_of_year
        "#{datetime.strftime('%b %e')}"
      else
        "#{datetime.strftime('%b %e, %Y')}"
      end
    end
  end

  def display_posted_time(object)
    created_at = object.created_at
    updated_at = object.updated_at
    posted = "Posted #{display_time_ago(created_at)}"
    updated = "updated #{time_from_in_words(created_at, updated_at)}"
    if updated_at != created_at
      "#{posted}, #{updated}"
    else
      "#{posted}"
    end
  end

  def time_from_in_words(from_time, to_time)
    "#{remove_unwanted_words(distance_of_time_in_words(from_time, to_time))} later"
  end

  def time_length_in_words(time)
    if time
      distance_of_time_in_words(time)
    else
      "-"
    end
  end

  def remove_unwanted_words string
    bad_words = ["less than", "about"]
    bad_words.each do |bad|
      string.gsub!(bad + " ", '')
    end
    return string
  end

end
