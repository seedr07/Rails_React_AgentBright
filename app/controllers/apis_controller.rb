class ApisController < ApplicationController

  require 'rubygems'
  require 'google/api_client'

  CLIENT_ID = Rails.application.secrets.social['google_id']
  CLIENT_SECRET = Rails.application.secrets.social['google_secret']
  CLIENT_SCOPE = "https://www.googleapis.com/auth/userinfo.profile https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/calendar.readonly"

  def new
    # Redirect to the Google URL
    redirect_to login_url.to_s
  end

  def create

    # Get user tokens from GoogleHelper
    user_tokens = get_tokens(params[:code])
    Rails.logger.info "User Tokens: #{user_tokens}"

    # Get the username from Google
    user_info = call_api('/oauth2/v2/userinfo', user_tokens['access_token'])

    Rails.logger.info "User Info: #{user_info}"

    # Get the user, if they exist
    # user = User.where(:uid => user_info['id']).first

    # # Create the user if they don't exist
    # if(user == nil)
    #   user = User.create(:email => user_info['email'], :first_name => user_info['given_name'], :last_name => user_info['family_name'], :role => 'User', :uid => user_info['id'], :refresh_token => user_tokens['refresh_token'], :access_token => user_tokens['access_token'], :expires => user_tokens['expires'])
    #   session[:user_id] = user.id

    # # Else update their info and save
    # else
    #   user.refresh_token = user_tokens['refresh_token']
    #   user.access_token = user_tokens['access_token']
    #   user.expires = user_tokens['expires_in']
    #   user.save

    #   session[:user_id] = user.id
    # end
    # Get the user, if they exist
    authorization = current_user.authorizations.google.find_by(email: user_info['email'])

    if authorization == nil
      authorization = Authorization.create(:user => current_user, :provider => 'Google', :email => user_info['email'], :first_name => user_info['given_name'], :last_name => user_info['family_name'], :uid => user_info['id'], :refresh_token => user_tokens['refresh_token'], :access_token => user_tokens['access_token'], :refresh_expires  => user_tokens['expires'])
    else
      authorization.refresh_token = user_tokens['refresh_token']
      authorization.access_token = user_tokens['access_token']
      authorization.expires_in = user_tokens['expires_in']
      authorization.save
    end

    # Redirect home
    redirect_to edit_integrations_path

  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end

  def report_dashboard
    @user = current_user
    render layout: "header-only"
  end

  def single_report_dashboard
    @user = current_user
    @api = params[:api]
    @api_responses = ApiResponse.where(api_type: @api).reverse
    render layout: "header-only"
  end
end
