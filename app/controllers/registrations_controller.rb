class RegistrationsController < Devise::RegistrationsController

  def create
    # if params[:user][:invite_code].to_s.strip != "24601"
    #   redirect_to new_user_registration_path, alert:"Please provide a valid invitation code!" and return
    # end
    super do
      analytics.track_user_creation
    end
    if resource.save
      @checkout = build_checkout
      @checkout.fulfill
      flash[:success] = "You are now registered with AgentBright, and your 30 day free trial has begun."
    else
      flash[:danger] = "Error creating new trial."
    end
  end

  protected

  def after_sign_up_path_for(resource)
    if resource.is_a?(User)
      profile_steps_path
    else
      super
    end
  end

  private

  def build_checkout
    plan = Plan.find_by(sku: "standard")
    user = current_user
    plan.checkouts.build(
      user: user,
      email: user.email
    )
  end

end
