class AuthorizationsController < ApplicationController

  def destroy
    @authorization = Authorization.find(params[:id])
    @authorization.destroy
    redirect_to edit_integrations_path
  end

  def add_inbox_email_address
    inbox = Nylas::API.new(nylas_id, nylas_secret, current_user.nylas_token)
    user_email = params[:email]
    callback_url = url_for(action: "inbox_login_callback")

    redirect_to inbox.url_for_authentication(callback_url, user_email, { state: params[:from_page] })
  end

  def inbox_login_callback
    if params[:code].present?
      save_user_token(fetch_new_token)
    end

    redirect_to path_for_redirect
  end

  def delete_nylas_token
    account_id_to_delete = current_user.nylas_account_id
    set_current_user_nylas_attributes_to_nil

    if NylasApi::Admin.new(account_id_to_delete).downgrade && current_user.save
    else
      flash.now[:danger] = "Sorry there was an error terminating your "\
        "account. Please try again."
    end
    redirect_to edit_integrations_path
  end

  def update_nilas_calendar_setting
    user = current_user
    user.nilas_calendar_setting_id = set_calendar_id
    if user.save
      redirect_to(
        edit_integrations_url,
        notice: "Successfully updated your calendar setting, please check "\
          "your dahsboard."
      )
    else
      redirect_to(
        edit_integrations_url,
        danger: "Sorry there was an error updating your calendar setting, "\
          "please try again."
      )
    end
  end

  private

  def nylas_id
    Rails.application.secrets.nylas["id"]
  end

  def nylas_secret
    Rails.application.secrets.nylas["secret"]
  end

  def fetch_new_token
    inbox = Nylas::API.new(nylas_id, nylas_secret, nil)
    nylas_token = inbox.token_for_code(params[:code])

    nylas_token
  rescue Nylas::APIError => e
    save_api_error_response(e)
    nil
  rescue SocketError => e
    save_api_error_response(e)
    nil
  end

  def save_api_error_response(e)
    ApiResponse.create!(
      api_type: "inboxapp",
      api_called_at: Time.current,
      status: "error",
      message: "Error occured while trying to connect
          with Nylas => #{e.inspect}"[0, 250]
    )
  end

  def set_calendar_id
    if params["calendar"]["id"] == "nil"
      nil
    else
      params["calendar"]["id"]
    end
  end

  def save_user_token(token)
    if token.present?
      current_user.nylas_token = token
      account = NylasApi::Account.new(token)
      current_user.nylas_connected_email_account = account.email_address
      current_user.nylas_account_id = account.account_id
      current_user.last_cursor = account.latest_cursor
      current_user.nylas_sync_status = account.sync_status
      current_user.save!
    end
  end

  def set_current_user_nylas_attributes_to_nil
    current_user.attributes = {
      nylas_token: nil,
      last_cursor: nil,
      nylas_account_id: nil,
      nylas_connected_email_account: nil,
      nylas_sync_status: nil
    }
  end

  def path_for_redirect
    if params[:state] == "import_contacts"
      dashboard_path
    else
      edit_integrations_path
    end
  end
end
