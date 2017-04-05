module UsersHelper

  def show_beta_features?
    user_signed_in? && current_user.show_beta_features
  end

end
