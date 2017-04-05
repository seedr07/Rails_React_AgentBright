require "test_helper"

class AlertsHelperTest < ActionView::TestCase

  fixtures :users

  def test_show_alert_if_processing_csv_file
    User.any_instance.stubs(:pending_csv_file?).returns(true)
    assert_equal(
      csv_file_processing_partial,
      show_alert_if_processing_csv_file(users(:john))
    )
  end

  def test_do_not_show_alert_if_processing_csv_file
    User.any_instance.stubs(:pending_csv_file?).returns(false)
    assert_equal(
      nil,
      show_alert_if_processing_csv_file(users(:john))
    )
  end

  private

  def csv_file_processing_partial
    render(partial: "shared/alerts/csv_file_processing")
  end

end
