module BootstrapFlashHelper

  MODIFIED_ALERT_TYPES = ["success", "info", "warning", "danger"].freeze

  def bootstrap_flash
    flash_messages = []

    flash.each do |type, message|
      compare_type = type.to_s
      # Skip empty messages
      # e.g. for devise messages set to nothing in a locale file.
      next if message.blank?

      compare_type = set_compare_type(compare_type)

      next unless MODIFIED_ALERT_TYPES.include?(compare_type)

      Array(message).each do |msg|
        text = content_tag(
          :div,
          msg.html_safe,
          class: "alert fade in alert-#{compare_type} "
        )
        flash_messages << text if msg
      end
    end

    flash_messages.join("\n").html_safe
  end

  private

  def set_compare_type(compare_type)
    case compare_type
    when "notice"
      "success"
    when "alert"
      "danger"
    when "error"
      "danger"
    end
  end

end
