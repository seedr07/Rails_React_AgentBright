class ProfileStepsController < ApplicationController

  layout "wizard"
  include Wicked::Wizard

  steps :business_information, :other_information, :import_contacts

  def show
    @user = current_user
    @csv_file = CsvFile.new.csv
    @csv_file.success_action_redirect = create_csv_file_upload_contacts_url
    render_wizard
  end

  def update
    @user = current_user
    @user.update_attributes!(user_params)
    if params[:profile_image_id].present?
      # Allow assign only images owned by user
      @user.profile_image = @user.images.find_by(id: params[:profile_image_id])
    end

    render_wizard @user
  end

  protected

  def user_params
    params.require(:user).permit(
      :ab_email_address,
      :address,
      :city,
      :company,
      :company_website,
      :contacts_database_storage,
      :country,
      :email,
      :fax_number,
      :first_name,
      :last_name,
      :mobile_number,
      :name,
      :office_number,
      :personal_website,
      :real_estate_experience,
      :state,
      :subscribed,
      :time_zone,
      :zip
    )
  end

end
