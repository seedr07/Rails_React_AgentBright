class MarketReportMessage

  attr_reader :contact, :email_campaign, :report, :report_date, :user

  delegate(
    :color_scheme,
    :display_custom_message,
    :custom_message,
    :subject,
    to: :email_campaign
  )
  delegate(
    :average_days_on_market_listings,
    :average_days_on_market_sold,
    :average_list_price,
    :average_sales_price,
    :location,
    :median_list_price,
    :median_sales_price,
    :number_of_listings,
    :number_of_new_listings,
    :number_of_sales,
    :original_vs_sales_price_ratio_avg_for_sale,
    :report_date_at,
    :sold_price_ratio_difference,
    :sold_price_ratio_difference_word,
    to: :report
  )

  def initialize(contact_id:nil, email_campaign_id:, month:nil, year:nil)
    @email_campaign = EmailCampaign.find(email_campaign_id)
    @contact = Contact.find(contact_id) if contact_id.present?
    @report_date = MarketData::ReportDateSelector.new.select(month: month, year: year)
    @user = @email_campaign.user
    @location_selector = MarketData::LocationSelector.new(contact_id: @contact.try(:id), user_id: @user.id, month: month, year: year)
  end

  def sender_name
    user.name
  end

  def sender_email
    user.email
  end

  def sender_phone
    user.mobile_number
  end

  def sender_has_team?
    user.belongs_to_team?
  end

  def sender_team_name
    user.team_name
  end

  def sender_image
    user.profile_image_url
  end

  def sender_company
    user.company
  end

  def recipient_name
    if contact
      contact.name
    else
      "Generic"
    end
  end

  def recipient_email
    if contact
      contact.primary_email_address.try(:email)
    end
  end

  def location
    @location_selector.select
  end

  def location_type
    location.class.name
  end

  def location_name
    location.name
  end

  def location_is_default?
    @location_selector.use_default_location?
  end

  def report
    @report ||= MarketReport.find_by(location: location, report_date_at: report_date)
  end

end
