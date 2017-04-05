module Dashboard::LeadStatsStatusHelper

  def daily_activities_completed_stat_block_status(activity_count, goal_count)
    ratio = activity_count.to_f / goal_count.to_f

    if ratio >= 0.999
      "success"
    elsif ratio < 0.999 && ratio > 0.7
      "warning"
    else
      "danger"
    end
  end

  def generate_dashboard_daily_open_leads_stat_block_status(open_leads_count)
    if open_leads_count > 0
      "danger"
    else
      "success"
    end
  end

  def generate_dashboard_daily_clients_no_action_stat_block_status(no_action_client_count)
    if no_action_client_count > 0
      "danger"
    else
      "success"
    end
  end

  def daily_tasks_completed_status(completed_count, due_and_overdue_count)
    ratio = completed_count.to_f / due_and_overdue_count.to_f

    if ratio >= 0.9
      "success"
    elsif ratio < 0.9 && ratio > 0.5
      "warning"
    else
      "danger"
    end
  end

end
