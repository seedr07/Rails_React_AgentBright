module PhoneNumbersHelper

  def display_phone_number(phone_number)
    number_to_phone(phone_number.number, area_code: true)
  end

  def phone_number_with_info(phone_number)
    number = display_phone_number(phone_number)
    type = phone_number.number_type
    "#{number} - #{type}"
  end

end
