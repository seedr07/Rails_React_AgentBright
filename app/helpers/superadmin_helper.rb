module SuperadminHelper

  def super_admin_signed_in?
    user_signed_in? && (current_user.super_admin? || masquerading?)
  end

  def authenticate_superadmin_user!(opts={})
    authenticate_user!(opts)
    redirect_to new_user_session_path unless current_user.super_admin?
  end

end
