require "test_helper"
require "datetime_formatting_helper"

class CommentsHelperTest < ActionView::TestCase

  include DatetimeFormattingHelper
  include Devise::Test::ControllerHelpers

  fixtures :comments, :leads, :users, :contacts

  def setup
    @nancy_user = users(:nancy)
    @katie_lead = leads(:katie)
    @comment = comments(:katie_3)
  end

  def test_show_commentable_link_contact_comment
    contact = contacts(:will)
    link = show_commentable_link(comments(:will_1))
    assert_equal(
      link_to(
        "Will O'Smith (Contact)",
        contact_path(contact),
        class: "small-meta fwb"
      ),
      link
    )
  end

  def test_show_commentable_link_lead
    link = show_commentable_link(@comment)
    assert_equal(
      link_to(
        "Katie Lozar0 - Client (Client)",
        lead_path(@katie_lead),
        class: "small-meta fwb"
      ),
      link
    )
  end

  def test_show_commentable_link_lead_status_0_comment
    @katie_lead.update_columns(status: 0)
    link = show_commentable_link(@comment)
    assert_equal(
      link_to(
        "Katie Lozar0 - Client (Lead)",
        lead_path(@katie_lead),
        class: "small-meta fwb"
      ),
      link
    )
  end

  def test_display_last_lead_comment
    ActionView::TestCase.any_instance.stubs(:current_user).returns(@nancy_user)
    assert_equal(
      render(
        partial: "comments/comment_block",
        locals: { comment: @katie_lead.most_recent_comment, lead: @katie_lead }
      ),
      display_last_lead_comment(@katie_lead)
    )
  end

  def test_display_last_lead_comment_when_comment_nil
    Lead.any_instance.stubs(:most_recent_comment).returns(nil)
    assert_equal nil, display_last_lead_comment(@katie_lead)
  end

  def test_display_last_lead_comment_longer_than_150
    ActionView::TestCase.any_instance.stubs(:current_user).returns(@nancy_user)
    Comment.any_instance.stubs(:content).returns("P" * 200)
    comment_block = render(
      partial: "comments/comment_block",
      locals: { comment: @katie_lead.most_recent_comment, lead: @katie_lead }
    )
    assert_equal(
      comment_block,
      display_last_lead_comment(@katie_lead)
    )
    assert_match(("P" * 200).to_s, comment_block)
  end

  def test_display_comment_author
    assert_equal "John", display_comment_author(@comment, @nancy_user)
    assert_equal "Me", display_comment_author(@comment, users(:john))
  end

  def test_last_lead_comment_more_link
    assert_equal nil, last_lead_comment_more_link(@comment, @katie_lead)
    Comment.any_instance.stubs(:content).returns("P" * 200)
    assert_equal(
      link_to("more", lead_path(@katie_lead, anchor: "comments")),
      last_lead_comment_more_link(@comment, @katie_lead)
    )
  end

end
