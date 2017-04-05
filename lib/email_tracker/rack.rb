module EmailTracker
  class Rack
    def initialize(app)
      @app = app
    end

    def call(env)
      req = ::Rack::Request.new(env)

      if req.path_info =~ /^\/inboxapp-message\/tracking\/(.+).png/
        details = Base64.decode64(Regexp.last_match[1])
        tracking_id = nil
        email_address = nil

        details.split("&").each do |kv|
          (key, value) = kv.split("=")
          case (key)
          when ("tracking_id")
            tracking_id = value
          when ("email_address")
            email_address = value
          end
        end

        if tracking_id && email_address
          filter_tracking_id = InboxMessage.where(opens_tracking_id: tracking_id)
          if filter_tracking_id.count > 0
            filter_email_address = filter_tracking_id.where(sent_to_email_address: email_address)
            if filter_email_address.count > 0
              inbox_message = InboxMessage.where(opens_tracking_id: tracking_id,
                                                 sent_to_email_address: email_address).first
              inbox_message.opened = true
              activity = InboxMessageActivity.new(inbox_message_id: inbox_message.id)
              activity.activity_event = "open"
              activity.ts = Time.zone.now
              inbox_message.save
              activity.save
            end
            Util.log "Unable to match Inbox Message with Inboxapp Message Activity
                     for email address: #{email_address} at #{Time.zone.now} with
                     tracking id: #{tracking_id}."
          end
        end

        [200, { "Content-Type" => "image/png" }, [File.read(File.join(File.dirname(__FILE__),
                                                  "track.png"))]]
      else
        @app.call(env)
      end
    end
  end
end
