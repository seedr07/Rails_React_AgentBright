require "activerecord/session_store"

class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception

  before_action :set_device_type
  before_action :set_layout_carrier
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  around_action :user_time_zone, if: :current_user
  before_action :set_honeybadger_context
  before_action :set_paper_trail_whodunnit

  before_action :redirect_if_subscription_inactive
  before_action :check_rack_mini_profiler

  add_flash_types :success, :info, :warning, :danger

  include PublicActivity::StoreController
  include SuperadminHelper
  include GoogleHelper
  helper DatetimeFormattingHelper
  helper DashboardHelper

  def analytics
    @analytics ||= Analytics.new(current_user, google_analytics_client_id)
  end

  def google_analytics_client_id
    google_analytics_cookie.gsub(/^GA\d\.\d\./, "")
  end

  def google_analytics_cookie
    cookies["_ga"] || ""
  end

  def redirect_if_subscription_inactive
    if current_user && !current_user_has_active_subscription?
      redirect_to billing_url
    end
  end

  protected

  def check_rack_mini_profiler
    if params[:rmp]
      Rack::MiniProfiler.authorize_request
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :first_name, :last_name])
  end

  def must_be_super_admin
    unless super_admin_signed_in?
      flash[:error] = "You do not have permission to view that page."
      redirect_to root_url
    end
  end

  def must_be_subscription_owner
    unless current_user_is_subscription_owner?
      deny_access("You must be the owner of this subscription")
    end
  end

  def current_user_is_subscription_owner?
    current_user_has_active_subscription? &&
      current_user.subscription.owner?(current_user)
  end
  helper_method :current_user_is_subscription_owner?

  def current_user_has_active_subscription?
    current_user && current_user.has_active_subscription?
  end
  helper_method :current_user_has_active_subscription?

  def masquerading?
    session[:admin_id].present?
  end
  helper_method :masquerading?

  def current_team
    current_user.team_group
  end
  helper_method :current_team_group

  def current_user_has_access_to?(feature)
    current_user && current_user.has_access_to?(feature)
  end

  private

  def user_time_zone(&block)
    Time.use_zone(current_user.time_zone, &block)
  end

  def set_device_type
    if browser.ua =~ /ABIOS/
      request.variant = :ios
    elsif browser.device.mobile? || browser.device.tablet?
      request.variant = :phone
    end
  end

  def set_layout_carrier
    @layout_carrier = LayoutCarrier.new
  end

  def set_honeybadger_context
    hash = {
      uuid: request.uuid,
      papertrail_url: "https://papertrailapp.com/events?time=#{Time.now.gmtime.to_i}",
    }
    hash.merge!(
      user_id: current_user.id,
      user_email: current_user.email,
      user_name: current_user.name
    ) if current_user
    Honeybadger.context hash
  end

  def deny_access(message)
    flash[:danger] = message
    redirect_to :back || root_url
  end

  def store_location
    session[:return_to] = request.fullpath
  end

  def set_referring_page(page=nil)
    session[:referring_page] = if page
                                 page
                               else
                                 request.referer
                               end
  end
  helper_method :set_referring_page

  def set_referring_page_with_backup(backup)
    session[:referring_page] = request.referer || backup
  end
  helper_method :set_referring_page_with_backup

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  def called_from_index_page?(controller=controller_name)
    request.referer =~ %r{/#{controller}$}
  end
  helper_method :called_from_index_page?

  def called_from_landing_page?(controller=controller_name)
    request.referer =~ %r{/#{controller}/\w+}
  end
  helper_method :called_from_landing_page?

  def current_page=(page)
    p = page.to_i
    @current_page = session[:"#controller_name}_current_page"] = (p.zero? ? 1 : p)
  end

  def current_page
    page = params[:page] || session[:"#controller_name}_current_page"] || 1
    @current_page = page.to_i
  end

end
