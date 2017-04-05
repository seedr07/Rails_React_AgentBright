class HomeController < ApplicationController

  before_action :set_contacts_csv_upload_status, only: [:index, :dashboard]

  def index
    @user = current_user
    @user.goals.create!(desired_annual_income: 0,
                        est_business_expenses: 0,
                        avg_price_in_area: 0, gross_commission_goal: 0,
                        gross_sales_vol_required: 0) unless @user.goals.present?
    @dashboard_carrier = DashboardCarrier.new(@user)

    @open_leads = Lead.leads_responsible_for(@user).contact_not_made.
                  order("incoming_lead_at desc").includes(:contact)
    set_contacts_csv_upload_status
    @tasks_completed_today = current_user.tasks.completed_today
    @tasks_completed_and_due_or_overdue_today = current_user.tasks.completed_today.
                                                due_before(Time.zone.now.end_of_day).
                                                limit(5)
    @not_completed_tasks = current_user.tasks_assigned.not_completed.
                           order("due_date_at asc").limit(5)
    @not_completed_tasks_assigned_to_other_teammates = current_user.team_tasks_assigned_to_other_teammates.not_completed.order("due_date_at asc").limit(5)
    @todays_and_overdue_tasks = @not_completed_tasks.due_before(Time.zone.now.end_of_day)
    @upcoming_tasks = @not_completed_tasks.due_after(Time.zone.now.end_of_day).limit(5 - @todays_and_overdue_tasks.count)
    @todays_and_overdue_team_tasks = @not_completed_tasks_assigned_to_other_teammates.due_before(Time.zone.now.end_of_day)
    @upcoming_team_tasks = @not_completed_tasks_assigned_to_other_teammates.due_after(Time.zone.now.end_of_day).limit(5 - @todays_and_overdue_team_tasks.count)
    @more_tasks = current_user.tasks_assigned.not_completed.length > 5 ? true : false
    @more_team_tasks = current_user.team_tasks_assigned_to_other_teammates.not_completed.length > 5 ? true : false
    @more_leads = current_user.open_leads_count > 5 ? true : false
    @task_queue = true
    analytics.track(
      event: "Load page",
      properties: {
        page: "Dashboard",
        browser: browser.meta,
        user_agent: request.user_agent
      }
    )
    @activities_completed_today = current_user.contact_activities.completed_today
    @clients_without_next_action = @user.clients_without_next_action
    @daily_completed = view_context.generate_daily_completed_stat(
      @activities_completed_today.count,
      @tasks_completed_and_due_or_overdue_today.count
    )
    @daily_remaining = view_context.generate_daily_remaining_stat(
      @dashboard_carrier.total_daily_referral_activities_goal,
      (@todays_and_overdue_tasks.count + @tasks_completed_and_due_or_overdue_today.count)
    )
    @leads_needing_action = Lead.needing_action(current_user).lead_status.not_snoozed.
                            includes(
                              contact: [:contact_image, :api_suggested_image],
                              lead_source: [], next_action: [], user: [],
                              properties: [:address],
                              incomplete_tasks: [:taskable, :assigned_to]
                            )
    @first_four_leads_needing_action = get_first_four_leads_needing_action
    @new_task = current_user.tasks.new
    @new_task_carrier = TaskCarrier.new(@new_task)
    @new_task.assigned_to = current_user

    _activities

    if current_user.initial_setup?
      render :dashboard
    else
      render "index"
    end
  end

  def dashboard
    redirect_to dashboard_url
  end

  def set_show_narrow_main_nav_bar
    current_user.update_attribute(:show_narrow_main_nav_bar, params[:is_narrow] == "true")
    render body: nil, status: 200, content_type: "text/html"
  end

  private

  def _activities
    @activities = PublicActivity::Activity.
      all.
      where(owner_id: current_user.team_member_ids).
      order("created_at desc").
      page(params[:activity_feed_page]).
      per(15)

    @activities_link_url = recent_activities_path(activities_owner_id: nil,
                                                  activities_owner_type: "Team",
                                                  activity_feed_page: @activities.next_page)
  end

  def set_contacts_csv_upload_status
    if flash[:csv_upload_success]
      if current_user.initial_setup?
        # On dashboard view display as notice instead.
        flash.now[:notice] = flash[:csv_upload_success]
      else
        @csv_upload_success_message = flash[:csv_upload_success]
      end
      flash.delete(:csv_upload_success)
    end
  end

  def get_first_four_leads_needing_action
    if @leads_needing_action.present?
      return @leads_needing_action.order(created_at: :desc).limit(4)
    end
    []
  end

  def get_remaining_leads_needing_action
    if @leads_needing_action && get_first_four_leads_needing_action.present?
      size = @leads_needing_action.size - get_first_four_leads_needing_action.size
      return @leads_needing_action.order(created_at: :desc).slice(4, size)
    end
    []
  end

end
