class UserSettings::LeadGroupsController < ApplicationController

  before_action :load_lead_group, except: [:new, :index, :create]
  before_action :load_lead_settings

  def index
    @lead_groups_owned = LeadGroup.where(owner: current_user)
    @lead_groups_part_of = current_user.lead_groups
    render layout: "header-only"
  end

  def new
    @lead_group = LeadGroup.new
  end

  def create
    @lead_group = LeadGroup.new(lead_group_params)
    @lead_group.owner = current_user
    @lead_group.users << current_user

    if @lead_group.save
      redirect_to(
        [:user_settings, @lead_group],
        notice: "Lead Group was successfully created."
      )
    else
      flash.now[:danger] = "Please check your entry and try again."
      render :new
    end
  end

  def show
    render
  end

  def edit
    render layout: "header-only"
  end

  def update
    if @lead_group.update(lead_group_params)
      redirect_to(
        [:user_settings, @lead_group],
        notice: "Lead Group was successfully updated."
      )
    else
      flash.now[:danger] = "Please check your entry and try again."
      render :new
    end
  end

  def destroy
    @lead_group.destroy
    redirect_to user_settings_lead_groups_path
  end

  def remove_user_from_lead_group
    user_to_remove = User.where(id: params[:member_id]).first
    @lead_group.users.delete(user_to_remove) unless user_to_remove.nil?
    redirect_to [:user_settings, @lead_group]
  end

  def add_user_to_lead_group
    new_agent_for_lead_group = User.where(email: lead_group_agent_params[:email]).first
    if new_agent_for_lead_group.blank?
      notice = "Agent with email #{lead_group_agent_params[:email]} not found!"
    elsif @lead_group.users.include? new_agent_for_lead_group
      notice = "Agent #{new_agent_for_lead_group.full_name} is already in this lead group."
    else
      @lead_group.users << new_agent_for_lead_group
      notice = "Added agent #{new_agent_for_lead_group.full_name} to the lead group."
    end
    redirect_to [:user_settings, @lead_group], notice: notice
  end

  def load_lead_settings
    @user = current_user
    @user.build_lead_setting_for_user
    @lead_setting = @user.lead_setting
    @user_lead_groups_owned_or_part_of = current_user.lead_groups_owned_or_part_of
    init_view_service
  end

  private

  def init_view_service
    @lead_setting_view_service = LeadSettingViewService.new(@lead_setting, current_user)
  end

  def lead_group_params
    params.require(:lead_group).permit(:name)
  end

  def lead_group_agent_params
    params.require(:lead_group_agent).permit(:email)
  end

  def load_lead_group
    @lead_group = LeadGroup.find(params[:id])
  end

end
