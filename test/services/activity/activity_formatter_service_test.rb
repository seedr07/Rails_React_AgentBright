require "test_helper"

class Activity::ActivityFormatterServiceTest < ActiveSupport::TestCase

  def test_format_for_grade
    title = "Grade"
    from  = Contact::GRADES[2][1] # => "2"
    to    = Contact::GRADES[3][1] # => "3"

    formatted_title, formatted_from, formatted_to = Activity::ActivityFormatterService.
                                                    format(title, from, to)

    assert_equal formatted_title, title
    assert_equal formatted_from, Contact::GRADES[2][0] # => "B"
    assert_equal formatted_to, Contact::GRADES[3][0]  # => "C"
  end

  def test_format_for_number
    title = "Number"
    from  = "1212333333"
    to    = "1212443333"

    formatted_title, formatted_from, formatted_to = Activity::ActivityFormatterService.
                                                    format(title, from, to)

    assert_equal formatted_title, title
    assert_equal formatted_from, "(121) 233-3333"
    assert_equal formatted_to,  "(121) 244-3333"
  end

  def test_format_for_status
    title = "Status"
    from  = Lead::STATUSES[0][1] # => "0"
    to    = Lead::STATUSES[1][1] # => "1"

    formatted_title, formatted_from, formatted_to = Activity::ActivityFormatterService.
                                                    format(title, from, to)

    assert_equal formatted_title, title
    assert_equal formatted_from, Lead::STATUSES[0][0] # => "Lead"
    assert_equal formatted_to, Lead::STATUSES[1][0]  # => "Prospect"
  end

  def test_format_for_property_types
    title = "Property type"
    from  = Lead::PROPERTY_TYPES[0][1] # => "0"
    to    = Lead::PROPERTY_TYPES[1][1] # => "1"

    formatted_title, formatted_from, formatted_to = Activity::ActivityFormatterService.
                                                    format(title, from, to)

    assert_equal formatted_title, title
    assert_equal formatted_from, Lead::PROPERTY_TYPES[0][0] # => "Single Family"
    assert_equal formatted_to, Lead::PROPERTY_TYPES[1][0]  # => "Multi-family"
  end

  def test_format_for_timeframes
    title = "Timeframe"
    from  = Lead::TIMEFRAMES[0][1] # => "0"
    to    = Lead::TIMEFRAMES[1][1] # => "1"

    formatted_title, formatted_from, formatted_to = Activity::ActivityFormatterService.
                                                    format(title, from, to)
    assert_equal formatted_title, title
    assert_equal formatted_from, Lead::TIMEFRAMES[0][0] # => "0-3 months"
    assert_equal formatted_to, Lead::TIMEFRAMES[1][0]  # => "3-6 months"
  end

  def test_format_for_contacted_status
    title = "Contacted status"
    from  = Lead::CLIENT_CONTACT_STATUSES[0][1] # => "0"
    to    = Lead::CLIENT_CONTACT_STATUSES[1][1] # => "1"

    formatted_title, formatted_from, formatted_to = Activity::ActivityFormatterService.
                                                    format(title, from, to)
    assert_equal formatted_title, title
    assert_equal formatted_from, Lead::CLIENT_CONTACT_STATUSES[0][0]
    assert_equal formatted_from, "Not Contacted"
    assert_equal formatted_to, Lead::CLIENT_CONTACT_STATUSES[1][0]
    assert_equal formatted_to, "Attempted Contact"
  end

  def test_format_for_date
    title = "Due date at"
    from  = "2014-12-26 12:58:03 UTC"
    to    = "2014-12-29 05:00:00 UTC"

    formatted_title, formatted_from, formatted_to = Activity::ActivityFormatterService.
                                                    format(title, from, to)
    assert_equal formatted_title, title
    assert_equal formatted_from, "12/26/2014"
    assert_equal formatted_to, "12/29/2014"
  end

  def test_format_for_decimal
    title = ""
    from  = "23434.00"
    to    = "674234.0"

    formatted_title, formatted_from, formatted_to = Activity::ActivityFormatterService.
                                                    format(title, from, to)
    assert_equal formatted_title, title
    assert_equal formatted_from, "23434.00"
    assert_equal formatted_to, "674234.0"
  end

  def test_format_for_currency
    title = "Additional fees"
    from  = "500002.00"
    to    = "800002.00"

    formatted_title, formatted_from, formatted_to = Activity::ActivityFormatterService.
                                                    format(title, from, to)
    assert_equal formatted_title, title
    assert_equal formatted_from, "$500,002"
    assert_equal formatted_to, "$800,002"
  end

  def test_format_for_percentage
    title = "Commission percentage"
    from  = "2.50"
    to    = "2.75"

    formatted_title, formatted_from, formatted_to = Activity::ActivityFormatterService.
                                                    format(title, from, to)
    assert_equal formatted_title, title
    assert_equal formatted_from, "2.50%"
    assert_equal formatted_to, "2.75%"
  end

end
