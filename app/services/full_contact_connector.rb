class FullContactConnector

  attr_accessor :email, :full_contact, :status

  def initialize(email)
    @email = email
    @full_contact = fetch_from_fullcontact
    set_api_response_status unless @full_contact.nil?
  end

  def status
    @status
  end

  def contact_info
    @full_contact.contact_info unless @full_contact.nil?
  end

  def demographics
    @full_contact.demographics unless @full_contact.nil?
  end

  def organizations
    @full_contact.organizations unless @full_contact.nil?
  end

  def photos
    @full_contact.photos unless @full_contact.nil?
  end

  def photo_url
    if photos && photos.first
      photos.first.url
    end
  end

  def social_profiles
    @full_contact.social_profiles unless @full_contact.nil?
  end

  private

  def fetch_from_fullcontact
    result = FullContact.person(email: @email)
    @status = result.status
    result
  rescue FullContact::Invalid
    Rails.logger.info "[FULLCONTACT] set status as 422"
    @status = 422
    return nil
  rescue FullContact::NotFound
    Rails.logger.info "[FULLCONTACT] set status as 404"
    @status = 404
    return nil
  rescue FullContact::Forbidden
    Rails.logger.info "[FULLCONTACT] set status as 403"
    @status = 403
    return nil
  end

  def response_status
    @full_contact.status unless @full_contact.nil?
  end

  def set_api_response_status
    Rails.logger.info "[FULLCONTACT] setting response status"
    if response_status == "200" || response_status == 200
      Rails.logger.info "[FULLCONTACT] set status as 200"
      @status = 200
    elsif response_status == "202" || response_status == 202
      Rails.logger.info "[FULLCONTACT] set status as 202"
      @status = 202
    else
      Rails.logger.info "[FULLCONTACT] #{@full_contact}"
    end
  end

end
