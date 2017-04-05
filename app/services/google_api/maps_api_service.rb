class GoogleApi::MapsApiService

  API_KEY  = Rails.application.secrets.social["google_map_api_key"]
  BASE_URI = "https://maps.googleapis.com/maps/api/staticmap"

  attr_reader :full_address

  def initialize(full_address)
    @full_address = full_address
  end

  def google_image_url
    @result ||= "#{BASE_URI}?#{params}"
  end

  private

  def params
    if Rails.env.production?
      # production doesn't need API_KEY as it is already grandfathered in.
      "zoom=14&scale=1&size=640x640&maptype=roadmap&markers=#{full_address}"
    else
      "key=#{API_KEY}&zoom=14&scale=1&size=640x640&maptype=roadmap&markers=#{full_address}"
    end
  end
end
