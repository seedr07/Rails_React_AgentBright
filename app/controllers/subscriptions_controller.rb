class SubscriptionsController < ApplicationController

  before_action :must_be_subscription_owner, only: [:edit, :update]
  skip_before_action :redirect_if_subscription_inactive

  def new
    @landing_page = LandingPage.new

    render layout: "header-only"
  end

  def edit
    @catalog = Catalog.new

    render layout: "header-only"
  end

  def update
    if current_user.subscription.change_plan(sku: params[:plan_id])
      redirect_to(
        profile_path,
        success: I18n.t("subscriptions.flashes.change.success")
      )
    else
      redirect_to(
        profile_path,
        warning: "Please add a card."
      )
    end
  end

end
