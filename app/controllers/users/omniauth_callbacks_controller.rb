class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  require "uuidtools"

  def facebook
    oauthorize "Facebook"
  end

  def twitter
    oauthorize "Twitter"
  end

  def linkedin
    oauthorize "LinkedIn"
  end

  def google_oauth2
    oauthorize "google_oauth2"
  end

  def passthru
    render file: "#{Rails.root}/public/404.html", status: 404, layout: false
  end

  private

  def oauthorize(kind)
    @user = find_for_oauth(kind, env["omniauth.auth"], current_user)
    if @user
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", kind: kind
      session["devise.#{kind.downcase}_data"] = env["omniauth.auth"]
      redirect_to edit_integrations_path
    end
  end

  def find_for_oauth(provider, access_token, resource=nil)
    user, email, name, uid, auth_attr = nil, nil, nil, {}
    case provider
    when "Facebook"
      uid = access_token["uid"]
      email = access_token["info"]["email"]
      auth_attr = {
        uid: uid,
        token: access_token["credentials"]["token"],
        secret: nil,
        first_name: access_token["info"]["first_name"],
        last_name: access_token["info"]["last_name"],
        name: access_token["info"]["name"],
        link: access_token["extra"]["raw_info"]["link"]
      }
    when "Twitter"
      uid = access_token["extra"]["raw_info"]["id"]
      name = access_token["extra"]["raw_info"]["name"]
      auth_attr = {
        uid: uid,
        token: access_token["credentials"]["token"],
        secret: access_token["credentials"]["secret"],
        first_name: access_token["info"]["first_name"],
        last_name: access_token["info"]["last_name"],
        name: name,
        link: "http://twitter.com/#{name}"
      }
    when "LinkedIn"
      uid = access_token["uid"]
      name = access_token["info"]["name"]
      auth_attr = {
        uid: uid,
        token: access_token["credentials"]["token"],
        secret: nil, first_name: access_token["info"]["first_name"],
        last_name: access_token["info"]["last_name"],
        link: access_token["info"]["public_profile_url"]
      }
    when "google_oauth2"
      uid = access_token["uid"]
      name = access_token["info"]["name"]
      email = access_token["info"]["email"]
      auth_attr = {
        uid: uid,
        token: access_token["credentials"]["token"],
        secret: nil,
        first_name: access_token["info"]["first_name"],
        last_name: access_token["info"]["last_name"],
        refresh_token: access_token["credentials"]["refresh_token"],
        refresh_expires: access_token["credentials"]["expires"],
        refresh_token_expires_at: access_token["credentials"]["expires_at"]
      }
    else
      raise "Provider #{provider} not handled"
    end
    if resource.nil?
      if email
        user = find_for_oauth_by_email(email, resource)
      elsif uid && name
        user = find_for_oauth_by_uid(uid, resource)
        if user.nil?
          user = find_for_oauth_by_name(name, resource)
        end
      end
    else
      user = resource
    end

    update_user_authorizations(
      user: user,
      provider: provider,
      auth_attr: auth_attr
    )

    user
  end

  def find_for_oauth_by_uid(uid, _resource=nil)
    if auth = Authorization.find_by_uid(uid.to_s)
      auth.user
    end
  end

  def find_for_oauth_by_email(email, _resource=nil)
    if user = User.find_by_email(email)
      user
    else
      user = User.create(email: email, password: Devise.friendly_token[0, 20])
    end
    user
  end

  def find_for_oauth_by_name(name, _resource=nil)
    if user = User.find_by_name(name)
      user
    else
      first_name = name
      last_name = name
      user = User.new(
        first_name: first_name,
        last_name: last_name,
        password: Devise.friendly_token[0, 20],
        email: "#{UUIDTools::UUID.random_create}@host"
      )
      user.save(validate: false)
    end
    user
  end

  def update_user_authorizations(user:, provider:, auth_attr:)
    auth = user.authorizations.find_by_provider(provider)
    if auth.nil?
      auth = user.authorizations.build(provider: provider)
      user.authorizations << auth
    end
    auth.update_attributes auth_attr
  end

end
