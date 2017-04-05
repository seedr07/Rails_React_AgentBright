class Users::SessionsController < Devise::SessionsController

  skip_before_action :redirect_if_subscription_inactive
  skip_before_action :verify_authenticity_token

  def new
    super do
      analytics.track_user_creation
    end
  end

  def create
    super do
      analytics.track_user_sign_in
    end
  end

end
