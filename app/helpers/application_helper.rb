module ApplicationHelper

  def get_initials_from_names(first_name, last_name)
    names = []
    names << first_name[0] if first_name.present?
    names << last_name[0]  if last_name.present?
    names.map(&:presence).join
  end

  def boolean_to_words(value)
    value ? "Yes" : "No"
  end

  def num_to_currency(amount)
    amount.nil? ? "-" : number_to_currency(amount, precision: 0)
  end

  def num_to_currency_truncated(amount)
    return "-" if amount.nil?
    if amount.to_i.to_s.size > 6
      "$#{amount.to_i / 1_000_000}m"
    else
      "$#{amount.to_i / 1_000}k"
    end
  end

  def commission_rate_to_s(rate)
    rate.nil? ? "-" : number_with_precision(rate, precision: 2).to_s
  end

  def decimal_to_percentage(decimal, precision: 0)
    decimal.nil? ? "-" : number_with_precision(decimal * 100, precision: precision).to_s
  end

  def decimal_rate_to_progress_bar(decimal)
    decimal.nil? ? 0 : number_with_precision(decimal * 100, precision: 0)
  end

  def fraction_to_percentage(numerator, denominator, precision: 0)
    if numerator && denominator && denominator > 0
      number_with_precision(numerator.to_f / denominator.to_f * 100, precision: precision)
    end
  end

  def progress_bar_sm(title, displayed_value, value, total)
    rate = if value && total > 0
             value.to_f / total.to_f * 100
           else
             0
           end
    render(
      partial: "shared/stats/progress_bar_small",
      locals: { title: title, displayed_value: displayed_value, rate: rate }
    )
  end

  def link_to_add_fields(name, f, association, directory_prefix="")
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(directory_prefix + association.to_s.singularize + "_fields", f: builder)
    end
    link_to(
      name,
      "",
      class: "add_fields clickable",
      data: { id: id, fields: fields.delete("\n") }
    )
  end

  def check_connection(provider)
    if current_user.has_connection_with(provider)
      auth = current_user.authorizations.where(provider: provider).first
      link_to(
        "Disconnect",
        auth,
        method: :delete,
        data: { confirm: "Are you sure?" },
        class: "btn btn-embossed btn-sm btn-primary btn-loading ",
        "data-loading-text" => "Disconnecting..."
      )
    end
  end

  def connection_status(provider)
    if current_user.has_connection_with(provider)
      "<span class='indicator-lg indicator-good'><span class='fui-check'></span></span>"
    else
      "<span class='indicator-lg indicator-bad'><span class='fui-cross'></span></span>"
    end
  end

  def underscored?(str_or_nil)
    str_or_nil.to_s =~ /_/
  end

  def slat_data_block(label=nil, value=nil)
    render(partial: "shared/slat_data_block", locals: { value: value, label: label })
  end

  def no_data_block(options={}, &block)
    if block
      options[:body] = capture(&block)
    end

    options[:icon_attributes] = nil unless options[:icon_attributes].present?
    options[:message] = nil unless options[:message].present?
    options[:block_id] = "emptymessage" unless options[:block_id].present?

    render(partial: "shared/no_data_block", locals: options)
  end

end
