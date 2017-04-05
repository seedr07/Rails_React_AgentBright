module CommentsHelper

  def show_commentable_link(comment)
    commentable = comment.commentable
    commentable_type = comment.commentable_type
    if commentable_type == "Contact"
      link_to(
        "#{commentable.full_name} (#{commentable_type})",
        commentable,
        class: "small-meta fwb"
      )
    elsif commentable_type == "Lead"
      if commentable.status == 0
        link_to("#{commentable.name} (Lead)", commentable, class: "small-meta fwb")
      else
        link_to("#{commentable.name} (Client)", commentable, class: "small-meta fwb")
      end
    end
  end

  def display_last_lead_comment(lead)
    if comment = lead.most_recent_comment
      render(
        partial: "comments/comment_block",
        locals: { lead: lead, comment: comment }
      )
    end
  end

  def display_comment_author(comment, current_user)
    if comment.user == current_user
      "Me"
    else
      comment.user.first_name
    end
  end

  def last_lead_comment_more_link(comment, lead)
    if comment.content.length > 150
      link_to("more", lead_path(id: lead.id, anchor: "comments"))
    end
  end

end
