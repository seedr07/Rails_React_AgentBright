class UserSettings::GeneralNotificationsController < ApplicationController

  before_action :load_lead_settings

  def index
    load_lead_settings
    render layout: "header-only"
  end

  private

  def load_lead_settings
    @user = current_user
    @user.build_lead_setting_for_user
    @lead_setting = @user.lead_setting
    init_view_service
  end

  def init_view_service
    @lead_setting_view_service = LeadSettingViewService.new(@lead_setting, current_user)
  end

end
