module Dashboard::LeadStatsHelper

  def generate_daily_completed_stat(activities, tasks)
    activities + tasks
  end

  def generate_daily_remaining_stat(goals, tasks)
    goals + tasks
  end

  def dashboard_daily_activities_completed_stat_block(activity_count, goal_count)
    if goal_count > 0
      block_status = daily_activities_completed_stat_block_status(activity_count, goal_count)
      dashboard_daily_activities_completed_stat_block_html(
        block_status,
        activity_count,
        goal_count
      )
    else
      dashboard_daily_activities_completed_stat_block_html("danger")
    end
  end

  def dashboard_daily_activities_completed_stat_block_html(block_status, activity_count=nil, goal_count=nil)
    if activity_count && goal_count
      stat_block(
        value: "#{activity_count}/#{goal_count}",
        label: "Marketing Activities Completed",
        columns: 3,
        link: "/marketing_center",
        block_status: block_status
      )
    else
      stat_block(
        value: "Marketing Center",
        label: "You have not yet created any goals!",
        columns: 3,
        link: "/marketing_center",
        block_status: block_status
      )
    end
  end

  def dashboard_daily_open_leads_stat_block(open_leads_count)
    block_status = generate_dashboard_daily_open_leads_stat_block_status(open_leads_count)
    generate_dashboard_daily_open_leads_stat_block_html(block_status, open_leads_count)
  end

  def generate_dashboard_daily_open_leads_stat_block_html(block_status, open_leads_count)
    stat_block(
      value: open_leads_count.to_s,
      label: "Leads Needing Action",
      columns: 4,
      link: "/leads",
      block_status: block_status
    )
  end

  def dashboard_daily_clients_no_action_stat_block(no_action_client_count)
    block_status = generate_dashboard_daily_clients_no_action_stat_block_status(no_action_client_count)
    daily_clients_no_action_block(block_status, no_action_client_count)
  end

  def daily_clients_no_action_block(block_status, no_action_client_count)
    stat_block(
      value: no_action_client_count.to_s,
      label: "Clients Without Next Actions",
      columns: 4,
      link: "#status-board",
      block_status: block_status
    )
  end

  def dashboard_daily_tasks_completed_stat_block(completed_count, due_and_overdue_count)
    if due_and_overdue_count > 0
      block_status = daily_tasks_completed_status(completed_count, due_and_overdue_count)
      daily_tasks_completed_block(block_status, completed_count, due_and_overdue_count)
    else
      block_status = "success"
      daily_tasks_completed_block(block_status)
    end
  end

  def daily_tasks_completed_block(block_status, completed_count=nil, due_and_overdue_count=nil)
    if completed_count && due_and_overdue_count
      stat_block(
        value: "#{completed_count}/#{due_and_overdue_count}",
        label: "Tasks Completed",
        columns: 4,
        link: "#tasks",
        block_status: block_status
      )
    else
      stat_block(
        value: "View Tasks",
        label: "You have no tasks that are due or overdue today.",
        columns: 4,
        link: "/tasks",
        block_status: block_status
      )
    end
  end

end
