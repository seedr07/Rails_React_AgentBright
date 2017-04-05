class EmailCampaignsController < ApplicationController

  before_action :load_email_campaign, only: [:show, :edit, :delete,
                                             :pre_delivery_emails_validation_merge,
                                             :deliver,
                                             :schedule, :replicate,
                                             :cancel_scheduling,
                                             :preview_content_html]

  before_action :load_email_campaigns, only: [:index, :search_email_campaigns]

  def create
    campaign = current_user.email_campaigns.build(name: "Draft", campaign_status: 0)
    if campaign.save!
      redirect_to edit_email_campaign_path(campaign)
    else
      redirect_to email_campaigns_path, notice:
      "Sorry there was an error creating your email campaign, please try again"
    end
  end

  def show
    render
  end

  def edit
    @user = current_user
    @email_validation_url = url_for controller: "email_campaigns", action: "validate_email"
    @campaign_index_url = url_for controller: "email_campaigns", action: "index"
  end

  def calculate_recipients_edit_page
    groups = params[:groups]
    contacts_string = params[:contacts]
    group_array = groups.split(",")
    contacts = Contact.tagged_with(group_array, any: true)
    user_contacts = contacts.where(user_id: current_user.id)
    emails = []
    user_contacts.each do |contact|
      if contact.primary_email_address
        if contact.primary_email_address.email
          emails << contact.primary_email_address.email
        end
      end
    end
    group_email_list = emails.join(",")
    api = MandrillApiService.new
    validated_list = api.validate_and_merge_emails(group_email_list, contacts_string)
    recipients_count = validated_list.split(",").count
    respond_to do |format|
      format.json { render json: recipients_count, msg: "recipients calculated" }
    end
  end

  def autosave_email_campaign
    time = params[:time]
    date = params[:date]
    image_id = params[:image_id]
    if image_id != ""
      image = Image.find(image_id)
    end
    if date && time && date != "" && time != ""
      scheduled_delivery = date + " " + time
    elsif date && date != ""
      scheduled_delivery = date
    else
      scheduled_delivery = nil
    end
    email_campaign = EmailCampaign.find(params[:campaign_id])
    email_campaign.update_attributes(autosave_params)
    if image
      email_campaign.campaign_image = image
    end
    if scheduled_delivery
      email_campaign.scheduled_delivery_at = Time.parse(scheduled_delivery)
    end
    email_campaign.save
    render nothing: true
  end

  def index
    @email_campaigns = current_user.email_campaigns.order("updated_at desc")
    render
  end

  def delete
    @email_campaign.destroy
    respond_to do |format|
      format.html { redirect_to email_campaigns_path }
      format.json { head :no_content }
    end
  end

  def destroy_multiple
    EmailCampaign.transaction do
      if params[:ids]
        params[:ids].each do |id|
          current_user.email_campaigns.find(id).destroy!
        end
      end
    end

    respond_to do |format|
      format.html { redirect_to contacts_url }
      format.json { head :no_content }
    end
  end

  def search_email_campaigns
    render layout: false
  end

  def send_test_email_campaign
    @user = current_user
    api = MandrillApiService.new
    email_campaign = EmailCampaign.find(params[:campaign_id])
    test_emails = params[:test_emails]
    if api.perform_test_email_delivery(email_campaign, test_emails)
      Util.log "Successfully delivered email campaign with id: #{email_campaign.id}
      on behalf of user with id: #{@user.id} at #{Time.zone.now}"
      response = "success"
      respond_to do |format|
        format.json { render json: response, msg: "delivered test email campaign" }
      end
    else
      Util.log "Failed to deliver email campaign with id: #{email_campaign.id}
      on behalf of user with id: #{@user.id} at #{Time.zone.now}"
      response = "fail"
      respond_to do |format|
        format.json { render json: response, msg: "failed to deliver email campaign" }
      end
    end
  end

  def validate_email
    email_list = params[:emails]
    validator = EmailValidationService.new
    valid_emails = validator.validate_and_return(email_list)
    respond_to do |format|
      format.json { render json: valid_emails, msg: "emails validated" }
    end
  end

  def deliver
    email_list = params[:email_list]
    api = MandrillApiService.new
    @email_campaign.campaign_status = 2
    @email_campaign.save!
    api.delay.deliver_campaign(@email_campaign, email_list)
    render nothing: true
  end

  def retreive_groups_contacts
    groups = params[:groups]
    group_array = groups.split(",")
    contacts = Contact.tagged_with(group_array, any: true)
    user_contacts = contacts.where(user_id: current_user.id)
    emails = []
    user_contacts.each do |contact|
      if contact.primary_email_address
        if contact.primary_email_address.email
          emails << contact.primary_email_address.email
        end
      end
    end
    return_string = emails.join(",")
    respond_to do |format|
      format.json { render json: return_string, msg: "contacts retreived" }
    end
  end

  def pre_delivery_emails_validation_merge
    groups_email_list = params[:groups]
    email_campaign = EmailCampaign.find(params[:id])
    api = MandrillApiService.new
    validated_list = api.validate_and_merge_emails(groups_email_list, email_campaign.contacts)
    respond_to do |format|
      format.json { render json: validated_list, msg: "list generated" }
    end
  end

  def contact_activity_report
    @contact = Contact.find(params[:id])
    @email_campaign = EmailCampaign.find(params[:campaign_id])
    @mandrill_message = MandrillMessage.where(email_campaign_id: @email_campaign.id,
                                              contact_id: @contact.id
                                              ).first
    if @mandrill_message
      @activities = @mandrill_message.mandrill_message_activities
    end
    render
  end

  def schedule
    @email_campaign.campaign_status = 1
    @email_campaign.save!
    render nothing: true
  end

  def replicate
    new_campaign = EmailCampaign.new
    new_campaign.title = @email_campaign.title
    new_campaign.image = @email_campaign.image
    new_campaign.contacts = @email_campaign.contacts
    new_campaign.content = @email_campaign.content
    new_campaign.groups = @email_campaign.groups
    new_campaign.user_id = @email_campaign.user_id
    new_campaign.campaign_status = 0
    new_campaign.subject = @email_campaign.subject
    new_campaign.name = @email_campaign.name + "(copy)"
    new_campaign.campaign_image = @email_campaign.campaign_image
    if new_campaign.save!
      redirect_to email_campaigns_path, notice: "Successfully replicated campaign"
    else
      redirect_to email_campaigns_path, notice: "Sorry
      there was an error replicating your campaign. Please try again"
    end
  end

  def cancel_scheduling
    @email_campaign.campaign_status = 0
    @email_campaign.save!
    render nothing: true
  end

  def retrieve_campaign_image
    @email_campaign = EmailCampaign.find(params[:campaign_id])
    url = @email_campaign.campaign_image_url
    respond_to do |format|
      format.json { render json: url, msg: "list generated" }
    end
  end

  def preview_content_html
    @user = current_user
    @email_campaign = EmailCampaign.find(params[:id])
    render layout: false
  end

  def remove_campaign_image
    @email_campaign = EmailCampaign.find(params[:id])
    @email_campaign.campaign_image = nil
    @email_campaign.save
    render nothing: true
  end

  private

  def load_email_campaign
    @email_campaign = EmailCampaign.find(params[:id])
  end

  def autosave_params
    params.
      slice(
        :campaign_status,
        :contacts,
        :content,
        :groups,
        :name,
        :subject,
        :title
      ).
      permit(
        :campaign_status,
        :contacts,
        :content,
        :groups,
        :name,
        :subject,
        :title
      )
  end

  def load_email_campaigns
    search_email_campaigns =
      if params[:search_term].present?
        current_user.email_campaigns.search_name(params[:search_term])
      else
        current_user.email_campaigns
      end

    campaign_status = params[:campaign_status]

    if campaign_status && campaign_status != "all"
      case campaign_status
      when "draft"
        search_email_campaigns = search_email_campaigns.draft
      when "sent"
        search_email_campaigns = search_email_campaigns.sent
      when "all"
        search_email_campaigns = search_email_campaigns.all
      end
    end

    order_by = params[:order_by] || "Draft"
    sort_direction = params[:sort_direction] || "asc"
    @email_campaigns = search_email_campaigns.order("#{order_by} #{sort_direction}").page(params[:page])
  end
end
