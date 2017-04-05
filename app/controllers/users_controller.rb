class UsersController < ApplicationController

  before_action :load_user, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_superadmin_user!, except: [:billing, :contacts_data]
  skip_before_action :redirect_if_subscription_inactive

  def index
    @users = User.all
  end

  def show
    render
  end

  def update
    if @user.update(user_params)
      sign_in(@user == current_user ? @user : current_user, bypass: true)
      redirect_to(
        session[:referring_page] || profile_url,
        success: "Successfully updated your profile."
      )
    else
      flash[:danger] = "Could not save your profile. Please try again."
      render "users/registrations/edit"
    end
  end

  def billing
    @plans = Plan.all
    render layout: "header-only"
  end

  def toggle_beta_features
    @user = current_user
    set_beta = !@user.show_beta_features
    if @user.update(show_beta_features: set_beta)
      redirect_to(
        :back || dashboard_path,
        success: "Now #{set_beta ? 'showing' : 'hiding'} beta features."
      )
    else
      redirect_to(
        :back || dashboard_path,
        danger: "Error toggling beta features."
      )
    end
  end

  def contacts_data
    render json: current_user.contacts_data_in_json(params[:q])
  end

  private

  def users_params
    params.require(:user).permit(:name, :email)
  end

  def load_user
    @user = User.find(params[:id])
  end

end
