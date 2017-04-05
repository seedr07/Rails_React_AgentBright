class UserSettings::EmailCampaignsController < ApplicationController
  layout "header-only"

  def show
    render
  end

  def update
    if current_user.update(user_params)
      redirect_to user_settings_email_campaigns_path,
                  success: "Successfully updated your profile."
    else
      flash.now[:danger] = "Could not save your profile. Please try again."
      render :show
    end
  end

  def user_params
    params.require(:user).permit(:email_campaign_track_opens, :email_campaign_track_clicks)
  end

end
