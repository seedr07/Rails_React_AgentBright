module ImportData
  class BaseRow

    JOIN_LAMBDA = ->(*args) { res = args.reject(&:blank?).map(&:strip).join(" ").presence }

    attr_reader :headers, :row

    def initialize(headers, row)
      @headers = headers
      @row = row
      @dict = {}

      headers.map.with_index do |h, i|
        @dict[h] ||= row[i]
      end
    end

    def [](key)
      @dict[key]
    end

    def evaluate_value(columns)
      if columns.is_a?(Array)
        func = columns[-1].respond_to?(:call) ? columns.pop : JOIN_LAMBDA
        func.call(*columns.map {|c| @dict[c]})
      else
        @dict[columns]
      end
    end

    def mapping_has_values?(mapping)
      mapping.any?{|title, attr| evaluate_value(title).present? }
    end

    def initiate_instance(instance, mapping)
      return unless mapping_has_values?(mapping)

      instance.tap do |instance_object|
        mapping.each do |title, attr|
          value = evaluate_value(title)
          if instance_object.respond_to?(attr)
            instance_object.send("#{attr}=", value) if instance_object.send(attr).blank?
          else
            if value.present?
              instance_object.data[attr] = value
              instance_object.data_will_change! # notify Rails, otherwise it won't be saved.
            end
          end
        end
      end
    end

    def primary_email_field? field
      ["E-mail Address", "Email", "E-mail"].include? field
    end

    def initialize_emails email_fields
      Rails.logger.info "[CSV.base_row] Initializing emails..."
      Rails.logger.info "[CSV.base_row] "
      email_addresses = []
      email_fields.each do |field|
        value = evaluate_value field
        if value.present?
          new_email = EmailAddress.new(
            email: value,
            primary: (primary_email_field?(field))
          )
          email_addresses << new_email
        end
      end
      existing_emails = email_addresses.select { |email_address| email_address.owner_id.present? }
      Rails.logger.info "[CSV.base_row] Email addresses: #{email_addresses.count}"
      Rails.logger.info "[CSV.base_row] Existing emails : #{existing_emails.count}"
      [email_addresses, existing_emails]
    end

    def initialize_phone_numbers phone_type_mappings
      Rails.logger.info "[CSV.base_row] Initializing phone numbers..."
      phone_numbers = []
      phone_type_mappings.keys.each do |field|
        value = evaluate_value field
        if value.present?
          phone_number = PhoneNumber.new(
            number: value,
            number_type: fetch_phone_type(field)
          )
          phone_numbers << phone_number
        end
      end
      existing_phone_numbers = phone_numbers.select { |phone_number| phone_number.owner_id.present? }
      Rails.logger.info "[CSV.base_row] Phone numbers: #{phone_numbers.count}"
      Rails.logger.info "[CSV.base_row] Existing phone numbers : #{existing_phone_numbers}"
      [phone_numbers, existing_phone_numbers]
    end
  end
end
