require 'test_helper'

class MailerHelperTest < ActionView::TestCase

  def test_successfully_generate_email_open_tracking_hidden_image
    open_tracking_id = RandomIdGenerator.new.id(25)
    hidden_image = generate_email_open_tracking_hidden_image(
                                                             open_tracking_id,
                                                             "john.smith.agentbright@gmail.com"
                                                            )
    assert_equal true, hidden_image.include?("img")
  end
end