module EventsHelper

  def event_location_url(event)
    if event.location
      full_address = convert_event_location_to_full_address(event.location)

      GoogleApi::MapsApiService.new(full_address).google_image_url
    else
      ""
    end
  end

  def event_has_unique_date_attribute(event, unique_date_label)
    if event.when
      (event.when["start_time"] && (event_cal_date_attribute(event) != unique_date_label)) ||
        (event.when["time"] && (event_cal_date_attribute(event) != unique_date_label)) ||
        (event.when["start_date"] && (event_cal_date_attribute(event) != unique_date_label))
    end
  end

  def event_cal_date_attribute(event)
    if event.when["start_time"]
      Time.zone.at(event.when["start_time"]).strftime("%-d")
    elsif event.when["start_date"]
      Time.zone.parse(event.when["start_date"]).strftime("%-d")
    elsif event.when["time"]
      Time.zone.at(event.when["time"]).strftime("%-d")
    end
  end

  def event_day_date_attribute(event)
    if event.when["start_time"]
      Time.zone.at(event.when["start_time"]).strftime("%b")
    elsif event.when["start_date"]
      Time.zone.parse(event.when["start_date"]).strftime("%b")
    elsif event.when["time"]
      Time.zone.at(event.when["time"]).strftime("%b")
    end
  end

  def formated_nilas_event_start_to_end_time(event)
    if event.when
      if event.when["start_time"] && event.when["end_time"]
        Time.zone.at(event.when["start_time"]).strftime("%l:%M") +
          "-" +
          Time.zone.at(event.when["end_time"]).strftime("%l:%M %p")
      elsif event.when["start_time"]
        Time.zone.at(event.when["start_time"]).strftime("%l:%M %p")
      elsif event.when["time"]
        Time.zone.at(event.when["time"]).strftime("%l:%M %p")
      end
    end
  end

  def convert_event_location_to_full_address(location)
    address_info = location.split(",")
    joiner = "+"

    address_info.select(&:present?).map do |info|
      info.gsub(" ", joiner)
    end.join(joiner)
  end

end
