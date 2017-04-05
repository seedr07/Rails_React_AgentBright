module AuthenticationHelper
  def signed_in?
    !session[:user_id].nil?
  end

  def current_user
    @current_user ||= User.find(session[:user_id])
  end

  def ensure_admin_signed_in
    # Redirect to the Google Account chooser if they're not logged in
    if !signed_in?
      session[:redirect_to] = request.url
      redirect_to new_session_path

    # Redirect to the homepage if they don't have permission to do what they're doing
    elsif current_user.is_not_administrator?
      redirect_to root_path
    end
  end
end