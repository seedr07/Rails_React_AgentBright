module DashboardHelper

  def grading_progress_bar_width(user)
    total_contacts = user.active_contacts_count
    ungraded_contacts = user.ungraded_contacts_count
    if total_contacts > 0
      percentage_graded = (total_contacts - ungraded_contacts).to_f / total_contacts * 100.00
      number_with_precision(percentage_graded, precision: 0)
    else
      0
    end
  end

end
