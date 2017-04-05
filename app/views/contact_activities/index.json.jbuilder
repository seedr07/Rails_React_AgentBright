json.array!(@contact_activities) do |contact_activity|
  json.extract! contact_activity, :activity_type, :subject, :completed_at, :comments
  json.url contact_activity_url(contact_activity, format: :json)
end
