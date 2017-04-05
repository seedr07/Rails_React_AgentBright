class ActivitiesController < ApplicationController

  before_action :load_current_date, only: :index

  def index
    all_activities
  end

  def recent
    case params[:activities_owner_type]
    when "Lead"
      lead_activities
    when "Contact"
      contact_activities
    when "Team"
      team_activities
    else
      all_activities
    end
  end

  private

  def load_current_date
    @current_date = params[:date] ? Chronic.parse(params[:date]).to_date : Date.current
  end

  def lead_activities
    lead                 = Lead.find(params[:activities_owner_id])
    @activities          = lead.recent_activities(page: params[:activity_feed_page])
    @activities_link_url = recent_activities_path(activities_owner_id: lead.id,
                                                  activities_owner_type: "Lead",
                                                  activity_feed_page: @activities.next_page)
  end

  def contact_activities
    contact              = Contact.find(params[:activities_owner_id])
    @activities          = contact.recent_activities(page: params[:activity_feed_page])
    @activities_link_url = recent_activities_path(activities_owner_id: contact.id,
                                                  activities_owner_type: "Contact",
                                                  activity_feed_page: @activities.next_page)
  end

  def team_activities
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

  def all_activities
    @activities = PublicActivity::Activity.all.order("created_at desc").page(params[:activity_feed_page]).per(100)
    @activities_link_url = recent_activities_path(activities_owner_id: nil,
                                                  activities_owner_type: nil,
                                                  activity_feed_page: @activities.next_page)
  end

end
