class FullContactInfoUpdater

  attr_accessor :contact
  attr_reader :full_contact

  def initialize(id)
    self.contact = Contact.find(id)
    @full_contact = FullContactConnector.new(email_address)
  end

  def update_all_and_save
    update_all
    Rails.logger.info "[FULLCONTACT] Loading fullcontact info"

    contact.save!
  end

  def update_all
    if full_contact.status == 200
      handle_successful_search
    elsif full_contact.status == 202
      handle_search_in_progress
    else
      handle_search_errors
    end
  end

  def save_contact
    contact.save!
  end

  def set_contact_info
    if contact_info = full_contact.contact_info
      contact.attributes = {
        suggested_first_name: contact_info.try(:given_name),
        suggested_last_name: contact_info.try(:family_name)
      }
    end
  end

  def set_location
    if location_deduced = full_contact.demographics.try(:location_deduced)
      contact.suggested_location = location_deduced.deduced_location
    end
  end

  def set_work_info
    if organization = full_contact.organizations.try(:first)
      contact.attributes = {
        suggested_organization_name: organization.try(:name),
        suggested_job_title: organization.try(:title)
      }
    end
  end

  def set_photo
    if url = full_contact.photo_url
      create_and_save_image(url)
    end
  end

  def set_social_info
    if profiles = full_contact.social_profiles
      profiles.each do |profile|
        set_profile_url(profile)
      end
    end
  end

  private

  def email_address
    contact.primary_email_address.try(:email)
  end

  def handle_successful_search
    set_successful_search_attributes

    set_contact_info
    set_location
    set_work_info
    set_photo
    set_social_info
  end

  def set_successful_search_attributes
    contact.attributes = {
      search_status: "Our API has found some information about this person",
      suggestion_received: Time.current,
      search_status_code: 200,
      search_status_message: "OK"
    }
  end

  def handle_search_in_progress
    contact.attributes = {
      search_status: "Search is in progress, please check this page again in a few minutes",
      suggestion_received: nil,
      search_status_code: 202,
      search_status_message: "Search in progress"
    }
  end

  def handle_search_errors
    contact.attributes = {
      search_status: "Search error",
      suggestion_received: nil,
      search_status_code: full_contact.status,
      search_status_message: "Search error"
    }
  end

  def set_profile_url(profile)
    case profile.type
    when "linkedin"
      contact.suggested_linkedin_url = profile.url
    when "facebook"
      contact.suggested_facebook_url = profile.url
    when "twitter"
      contact.suggested_twitter_url = profile.url
    when "googleplus"
      contact.suggested_googleplus_url = profile.url
    when "instagram"
      contact.suggested_instagram_url = profile.url
    when "youtube"
      contact.suggested_youtube_url = profile.url
    end
  end

  def create_and_save_image(url)
    if image = Image.new(remote_file_url: process_url(url))
      image.save!
      contact.api_suggested_image = image
      contact.contact_image = image if contact.contact_image.nil?
    end
  end

  def process_url(uri)
    require "open-uri"
    require "open_uri_redirections"
    open(uri, allow_redirections: :safe) do |r|
      r.base_uri.to_s
    end
  rescue OpenURI::HTTPError => e
    Util.log "Error procssing URL: #{e}"
    return nil
  end

end
