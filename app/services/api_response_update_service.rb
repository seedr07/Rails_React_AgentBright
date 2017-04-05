class ApiResponseUpdateService

  def update_api_responses
    api = ApiResponse.new
    if time_to_ping_fullcontact?
      update_fullcontact_api_response(api)
    end
  end

  def update_fullcontact_api_response(api)
    api_key = Rails.application.secrets.fullcontact_api_key
    time_period = Time.zone.now.strftime("%Y-%m")
    string_url = "https://api.fullcontact.com/v2/stats.json?period=#{time_period}&apiKey=#{api_key}"
    url = URI(string_url)
    begin
      response = Net::HTTP.get(url)
    rescue Exception => e
      api.api_type = "fullcontact.ping"
      api.api_called_at = Time.zone.now
      api.status = "Error - Connecting"
      api.message = "Error in connecting with
       FullContact API => #{e.inspect}"[0, 250] # avoid pg string error
      api.save!
      response = nil
      logger.info "error in ApiResponseUpdateService#update_fullcontact_api_response -> #{e}"
    end
    if response
      begin
        hash = JSON.parse(response)
      rescue Exception => e
        api.api_type = "fullcontact.ping"
        api.api_called_at = Time.zone.now
        api.status = "Error - JSON Parsing"
        api.message = "Error JSON Parsing of FullContact
          API response => #{e.inspect}"[0, 250] # avoid pg string error
        api.save!
        hash = nil
        logger.info "error in json parsing response in
                    ApiResponseUpdateService#update_fullcontact_api_response -> #{e}"
      end
      if hash
        api.api_type = "fullcontact.ping"
        api.api_called_at = Time.zone.now
        api.status = hash["status"]
        if hash["metrics"]
          hash["metrics"].each do |metric|
            if metric["metricId"] == "200"
              api.message = "FullContact Successful API calls remaining
              this month(#{time_period}) : #{metric["remaining"]} "[0, 250]
              # avoid pg string error
            end
          end
        end
        api.save!
      end
    end
  end

  def time_to_ping_fullcontact?
    fullcontact_pings = ApiResponse.where(api_type: "fullcontact.ping")
    if fullcontact_pings.length > 0
      last_ping = fullcontact_pings.last
      (Time.zone.now.to_i - last_ping.api_called_at.to_i) > 1800
    else
      true
    end
  end

end
