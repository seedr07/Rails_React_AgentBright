class CommentCarrier

  # Why we should use carrier, please check this
  # http://blog.bigbinary.com/2014/12/02/drying-up-rails-views-with-view-carriers-and-services.html

  attr_reader :comment

  def initialize(comment)
    @comment = comment
  end

  def handle_display_style(value)
    "display:#{comment.commentable_type == value ? 'block' : 'none'}"
  end

  def set_checked_radio_button_for_associated
    return "None" if comment.new_record? || comment.commentable == nil
    return "Lead/Client" if comment.commentable_type == "Lead"
    return "Contact" if comment.commentable_type == "Contact"

    comment.commentable_type
  end

  def showable_set_next_action_modal?(from_page, incomplete_comments)
    from_page == "home-index" && incomplete_comments.blank?
  end

end