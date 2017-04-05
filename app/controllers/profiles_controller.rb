class ProfilesController < ApplicationController

  before_action :authenticate_user!
  before_action :find_user

  def show
    render :edit, layout: "header-only"
  end

  def edit
    render layout: "header-only"
  end

  def update
    # HACK: with pretty form we don't receive this value as 0 if not checked
    if @user.update(user_params)
      remove_profile_image
      update_commission_data
      if params[:from_page] == "edit_broker_fees"
        redirect_to edit_commission_split_path, notice: "Commission updated!"
      else
        redirect_to edit_profile_path, notice: t(".done")
      end
    else
      flash.now[:danger] = t(".error")
      if params[:from_page] == "edit_broker_fees"
        render "edit_commission_split", layout: "header-only"
      else
        render "edit", layout: "header-only"
      end
    end
  end

  def edit_commission_split
    @commission_carrier = CommissionCarrier.new(@user)
    render layout: "header-only"
  end

  def edit_integrations
    @active_google_authorizations = current_user.authorizations.google
    @authorization = current_user.authorizations.new
    if current_user.has_nylas_token?
      @nylas_account = NylasApi::Account.new(current_user.nylas_token)
    end
    render layout: "header-only"
  end

  def save_email_signature
    if current_user.update(user_params)
      flash[:notice] = "Emails settings successfully saved!"
      redirect_to edit_integrations_path
    else
      flash[:error] = "Emails settings didn't get saved!"
      redirect_to edit_integrations_path
    end
  end

  def edit_calendar_settings
    calendar = NylasApi::Calendar.new(current_user)
    if calendar
      @calendars = calendar.all
    end
    render "authorizations/calendar_settings", layout: "header-only"
  end

  def destroy
    @authorization = Authorization.find(params[:id])
    @authorization.destroy
    respond_to do |format|
      format.html { redirect_to edit_integrations_path }
      format.js
      format.json { head :no_content }
    end
  end

  private

  def find_user
    @user = current_user
  end

  def sanitize_price_fields_params(users_params)
    [:monthly_broker_fees_paid, :broker_fee_per_transaction, :annual_broker_fees_paid].each do |price_field|
      users_params[price_field] = sanitize_price(users_params[price_field]) if users_params[price_field].present?
    end

    users_params
  end

  def sanitize_price(price_value)
    price_value.delete(",")
  end

  def remove_profile_image
    if params[:remove_profile_image] == "true"
      current_user.profile_image.destroy
    end
  end

  def user_params
    unsanitized_users_params = params.require(:user).permit(
      :ab_email_address,
      :address,
      :agent_percentage_split,
      :annual_broker_fees_paid,
      :broker_fee_alternative,
      :broker_fee_alternative_split,
      :broker_fee_per_transaction,
      :broker_percentage_split,
      :city,
      :commission_split_type,
      :company,
      :company_website,
      :contacts_database_storage,
      :country,
      :email,
      :fax_number,
      :first_name,
      :franchise_fee,
      :franchise_fee_per_transaction,
      :id,
      :last_name,
      :lead_form_key,
      :mobile_number,
      :monthly_broker_fees_paid,
      :name,
      :office_number,
      :per_transaction_fee_capped,
      :personal_website,
      :real_estate_experience,
      :state,
      :time_zone,
      :transaction_fee_cap,
      :zip,
      :email_signature,
      :email_signature_status,
      :team_name
    )
    sanitize_price_fields_params(unsanitized_users_params)
  end

  def update_commission_data
    if params[:from_page] == "edit_broker_fees"
      leads = @user.leads.updatable_for_commission_data
      UpdateCommissionDataService.new(leads).delay.process
    end
  end

end
