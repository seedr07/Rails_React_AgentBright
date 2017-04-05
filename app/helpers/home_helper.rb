module HomeHelper

  def progress_bar(title, counter, goal)
    goal_was_met = counter >= goal
    goal_percent_completed = (goal_was_met ? 100 : (counter * 100 / goal))
    render(
      partial: "shared/stats/progress_bar",
      locals: {
        counter: counter,
        goal: goal,
        goal_was_met: goal_was_met,
        goal_percent_completed: goal_percent_completed,
        title: title
      }
    )
  end

  def data_for_sorting_complete(active_contacts_count, ungraded_contacts_count)
    if active_contacts_count == 0
      0
    else
      active_graded_contacts_count = active_contacts_count - ungraded_contacts_count
      sorting_complete_count = active_graded_contacts_count.to_f / active_contacts_count
      number_with_precision(sorting_complete_count * 100.00, precision: 0)
    end
  end

  def display_avatar(object, size=50)
    if image = object.display_image
      url = image.file.url
      content_tag(
        :span,
        "",
        class: "avatar-round avatar-size-#{size} #{image.attachable_class}",
        style: "background-image: url('#{url}')"
      )
    elsif initial = object.initial
      color = object.avatar_class
      content_tag(:span, initial.upcase, class: "avatar-round avatar-size-#{size} #{color}")
    else
      color = object.avatar_class
      content_tag(:span, "N/A", class: "avatar-round avatar-size-#{size} #{color}")
    end
  end

end
