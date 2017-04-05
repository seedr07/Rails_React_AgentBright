class CheckoutsController < ApplicationController

  before_action :redirect_when_plan_not_found
  skip_before_action :redirect_if_subscription_inactive

  def new
    if current_user_has_active_subscription?
      redirect_to(
        edit_subscription_path,
        notice: t("checkout.flashes.already_subscribed")
      )
    else
      @checkout = build_checkout({})
      render layout: "header-only"
    end
  end

  def create
    @checkout = build_checkout(checkout_params)

    if @checkout.fulfill
      session.delete(:coupon)
      sign_in_and_redirect
    else
      render :new
    end
  end

  private

  def redirect_when_plan_not_found
    unless plan.present?
      redirect_to(
        new_checkout_path(plan: Plan.popular),
        notice: I18n.t("checkout.flashes.plan_not_found")
      )
    end
  end

  def build_checkout(arguments)
    plan.checkouts.build(arguments.merge(default_params))
  end

  def default_params
    if current_user
      {
        user: current_user,
        email: current_user.email,
        stripe_customer_id: current_user.stripe_customer_id,
        stripe_coupon_id: session[:coupon],
        trial: false
      }
    else
      {
        stripe_coupon_id: session[:coupon]
      }
    end
  end

  def sign_in_and_redirect
    sign_in @checkout.user

    redirect_to(
      success_url,
      notice: t("checkout.flashes.success", name: @checkout.plan_name),
      flash: { purchase_amount: @checkout.price }
    )
  end

  def success_url
    if @checkout.plan_includes_team_group?
      edit_team_group_path
    else
      billing_path
    end
  end

  def url_after_denied_access_when_signed_out
    sign_up_url
  end

  def checkout_params
    params.require(:checkout).permit(
      :billing_address,
      :billing_address_2,
      :billing_city,
      :billing_country,
      :billing_organization,
      :billing_state,
      :billing_zip_code,
      :email,
      :first_name,
      :last_name,
      :password,
      :payment_method,
      :quantity,
      :stripe_token
    )
  end

  def plan
    Plan.find_by(sku: params[:plan])
  end

end
