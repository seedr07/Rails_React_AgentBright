class DashboardCarrier

  attr_reader :user, :goal, :team

  delegate :total_daily_referral_activities_goal, to: :goal
  delegate :daily_calls_goal, to: :goal
  delegate :daily_notes_goal, to: :goal
  delegate :daily_visits_goal, to: :goal

  def initialize(user)
    @user = user
    @goal = user.last_goal
  end

  def open_leads
    Lead.leads_responsible_for(user).
      contact_not_made.
      order("incoming_lead_at desc").
      includes(:contact)
  end

  def open_leads_count
    open_leads.count
  end

  def open_clients
    @open_clients ||= user.leads.open_clients.includes(
      contact: [:contact_image, :api_suggested_image],
      lead_source: [],
      next_action: [],
      user: [],
      properties: [:address],
      incomplete_tasks: [:taskable, :assigned_to]
    ).to_a
  end

  def open_team_clients
    @open_team_clients ||= user.team_leads.open_clients.includes(
      contact: [:contact_image, :api_suggested_image],
      lead_source: [],
      next_action: [],
      user: [],
      properties: [:address],
      incomplete_tasks: [:taskable, :assigned_to]
    ).to_a
  end

  def long_term_prospects
    @long_term_prospects ||= user.leads.client_long_term_prospect_due.includes(
      contact: [:contact_image, :api_suggested_image],
      lead_source: [],
      user: [],
      properties: [:address],
      incomplete_tasks: [:taskable, :assigned_to]
    )
  end

  def long_term_prospects_team
    @long_term_prospects_team ||= user.team_leads.client_long_term_prospect_due.includes(
      contact: [:contact_image, :api_suggested_image],
      lead_source: [],
      next_action: [],
      user: [],
      properties: [:address],
      incomplete_tasks: [:taskable, :assigned_to]
    )
  end

  def clients_without_next_action
    user.clients_without_next_action
  end

  def clients_without_next_action_count
    clients_without_next_action.count
  end

  def team_clients_without_next_action
    user.team_clients_without_next_action
  end

  def team_clients_without_next_action_count
    team_clients_without_next_action.count
  end

  def tasks_completed_today
    user.tasks.completed_today
  end

  def team_tasks_completed_today
    user.team_tasks.completed_today
  end

  def tasks_completed_and_due_or_overdue_today
    tasks_completed_today.due_before(Time.current.end_of_day)
  end

  def team_tasks_completed_and_due_or_overdue_today
    team_tasks_completed_today.due_before(Time.current.end_of_day)
  end

  def not_completed_tasks
    user.tasks_assigned.not_completed.all.order("due_date_at asc")
  end

  def team_not_completed_tasks
    user.team_tasks_assigned.not_completed.all.order("due_date_at asc")
  end

  def todays_and_overdue_tasks
    not_completed_tasks.due_before(Time.current.end_of_day)
  end

  def todays_and_overdue_team_tasks
    team_not_completed_tasks.due_before(Time.current.end_of_day)
  end

  def todays_task_progress_completed
    tasks_completed_and_due_or_overdue_today.count
  end

  def todays_task_progress_total
    todays_and_overdue_tasks.count + todays_task_progress_completed
  end

  def todays_team_task_progress_completed
    team_tasks_completed_and_due_or_overdue_today.count
  end

  def todays_team_task_progress_total
    todays_and_overdue_team_tasks.count + todays_team_task_progress_completed
  end

  def statuses_to_show_on_board
    [1, 2, 3]
  end

  def clients_by_status_count(status, team=nil)
    clients_by_status(status, team).size
  end

  def buyer_clients_by_status(status, team=nil)
    clients_by_status(status, team).select(&:buyer?).
      sort_by { |lead| lead.contact.try(:first_name) }
  end

  def listing_clients_by_status(status, team=nil)
    clients_by_status(status, team).select(&:listing?).
      sort_by { |lead| lead.contact.try(:first_name) }
  end

  def buyer_clients_by_status_present?(status, team=nil)
    buyer_clients_by_status(status, team).present?
  end

  def listing_clients_by_status_present?(status, team=nil)
    listing_clients_by_status(status, team).present?
  end

  def status_header(status)
    Lead::STATUS_HEADERS[status]
  end

  def activities(page=nil)
    PublicActivity::Activity.
      all.
      where(owner_id: user.team_member_ids).
      order("created_at desc").
      page(page).
      per(15)
  end

  private

  def clients_by_status(status, team=nil)
    if team == :team
      open_team_clients.select { |client| client.status == status }
    else
      open_clients.select { |client| client.status == status }
    end
  end
end
