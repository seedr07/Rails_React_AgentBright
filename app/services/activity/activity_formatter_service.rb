class Activity::ActivityFormatterService

  def self.format(title, from, to)
    title, from, to = case title.gsub(/\d/, "")
                      when "Grade"
                        format_grade(title, from, to)
                      when "Number"
                        format_phone_number(title, from, to)
                      when "Status"
                        format_status(title, from, to)
                      when "Property type"
                        format_property_type(title, from, to)
                      when "Timeframe"
                        format_timeframe(title, from, to)
                      when "Contacted status"
                        format_contacted_status(title, from, to)
                      else
                        [title, from, to]
                      end

    Rails.logger.debug "[ACTIVITY.formatter] Title: #{title}"
    Rails.logger.debug "[ACTIVITY.formatter] from: #{from} to: #{to}"
    from, to = format_date(title, from, to)
    Rails.logger.debug "[ACTIVITY.formatter] from: #{from} to: #{to}"
    from, to = format_currency(title, from, to)
    Rails.logger.debug "[ACTIVITY.formatter] from: #{from} to: #{to}"
    from, to = format_percentage(title, from, to)

    [title, from, to]
  end

  class << self

    private

    def format_grade(title, from, to)
      if from.blank?
        [title, '', Contact::GRADES[to.to_i][0]]
      else
        [title, Contact::GRADES[from.to_i][0], Contact::GRADES[to.to_i][0]]
      end
    end

    def format_phone_number(title, from, to)
      from = ActionController::Base.helpers.number_to_phone(from, area_code: true)
      to   = ActionController::Base.helpers.number_to_phone(to, area_code: true)

      [title, from, to]
    end

    def format_status(title, from, to)
      lead_array_converter("STATUSES", title, from, to)
    end

    def format_property_type(title, from, to)
      lead_array_converter("PROPERTY_TYPES", title, from, to)
    end

    def format_timeframe(title, from, to)
      lead_array_converter("TIMEFRAMES", title, from, to)
    end

    def format_contacted_status(title, from, to)
      lead_array_converter("CLIENT_CONTACT_STATUSES", title, from, to)
    end

    def format_date(title, from, to)
      Rails.logger.debug "[ACTIVITY.formatter] Formatting date..."
      title = convert_to_symbol(title)

      if date_attribues.include? title
        Rails.logger.debug "[ACTIVITY.formatter] Included in date attributes."
        from = convert_to_date(from)
        to = convert_to_date(to)
      end

      [from, to]
    end

    def format_currency(title, from, to)
      title = convert_to_symbol(title)
      Rails.logger.debug "[ACTIVITY.formatter] Symbol title: #{title}"

      if currency_attributes.include? title
        Rails.logger.debug "[ACTIVITY.formatter] Included in currency attributes."
        from = convert_to_currency(from)
        to = convert_to_currency(to)
      end

      [from, to]
    end

    def format_percentage(title, from, to)
      title = convert_to_symbol(title)
      Rails.logger.debug "[ACTIVITY.formatter] Symbol title: #{title}"

      if percentage_attributes.include? title
        Rails.logger.debug "[ACTIVITY.formatter] Included in percentage attributes."
        from = convert_to_percentage(from)
        to = convert_to_percentage(to)
      end

      [from, to]
    end

    def format_00_decimal(from, to)
      from = remove_00_decimal(from)
      to   = remove_00_decimal(to)

      [from, to]
    end

    def convert_to_date(date)
      return date if date.blank?

      DateTime.parse(date).strftime("%m/%d/%Y")
    end

    def date_attribues
      [
        :attempted_contact_at,
        :closing_date_at,
        :completed_at,
        :created_at,
        :displayed_closing_date_at,
        :due_date_at,
        :graded_at,
        :inactive_at,
        :incoming_lead_at,
        :last_activity_at,
        :last_broadcast_at,
        :last_called_at,
        :last_contacted_at,
        :last_note_sent_at,
        :last_visited_at,
        :lead_followup_reminder_time,
        :listing_expires_at,
        :lost_date_at,
        :next_activity_at,
        :next_call_at,
        :next_note_at,
        :next_visit_at,
        :offer_accepted_date_at,
        :offer_deadline_at,
        :original_list_date_at,
        :pause_date_at,
        :suggestion_received,
        :updated_at,
        :unpause_date_at
      ]
    end

    def convert_to_currency(decimal)
      return decimal if decimal.blank?

      ActionController::Base.helpers.number_to_currency(decimal, precision: 0)
    end

    def currency_attributes
      [
        :additional_fees,
        :amount_owed,
        :broker_commission_fee,
        :closing_price,
        :commission_fee,
        :commission_fee_buyer_side,
        :commission_fee_total,
        :commission_flat_fee,
        :incoming_lead_price,
        :initial_agent_valuation,
        :initial_client_valuation,
        :list_price,
        :max_price_range,
        :min_price_range,
        :offer_price,
        :original_list_price,
        :referral_fee_flat_fee,
        :referral_fees
      ]
    end

    def convert_to_percentage(value)
      return value if value.blank?

      "#{value}%"
    end

    def percentage_attributes
      [
        :broker_commission_percentage,
        :commission_percentage,
        :commisison_percentage_buyer_side,
        :commisison_percentage_total,
        :commission_rate,
        :referral_fee_rate
      ]
    end

    def remove_00_decimal(value)
      Rails.logger.debug "[ACTIVITY.formatter] Removing decimal..."
      Rails.logger.debug "[ACTIVITY.formatter] Old value: #{value}"
      result = value.gsub(/.0+$/, "")
      Rails.logger.debug "[ACTIVITY.formatter] New value: #{result}"
      result
    end

    def convert_to_symbol(title)
      title.downcase.tr(" ", "_").to_sym
    end

    def lead_array_converter(array_name, title, from, to)
      array = ("Lead::" + array_name).constantize
      [title, array.select { |e| e.include?(from.to_i) }[0][0],
       array.select { |e| e.include?(to.to_i) }[0][0]]
    end

  end

end
