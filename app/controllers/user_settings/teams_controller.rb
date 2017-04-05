class UserSettings::TeamsController < ApplicationController

  before_action :load_team

  def index
    init_view_service
    @pending_team_requests = current_user.teammates.pending_request
    render layout: "header-only"
  end

  def add_user_to_team
    notice = Team.add_teammate teammate_params[:email], current_user
    redirect_to user_settings_teams_path, notice: notice
  end

  def remove_user_from_team
    Team.remove_teammate params[:member_id], current_user
    redirect_to user_settings_teams_path
  end

  def accept_request_to_join_team
    teammate_to_confirm = Teammate.where(id: params[:teammate_id]).first
    teammate_to_confirm.confirm_teammates
    redirect_to user_settings_teams_path
  end

  def decline_request_join_team
    Teammate.delete(params[:teammate_id])
    redirect_to user_settings_teams_path
  end

  def teammate_params
    params.require(:teammate).permit(:email)
  end

  def load_team
    @team = current_user.team_owned_by_user
    @teammates = current_user.team_owned.teammates
  end

  def init_view_service
    @team_view_service = TeamsViewService.new(@team)
  end

end
