class Activity::UnwantedChangesRemoverService
  attr_reader :activity_changes

  def initialize(activity_changes)
    @activity_changes = activity_changes
  end

  def perform
    activity_changes.except(*unwanted_attributes).reject do |attr, v|
      v.all?(&:blank?) || attr =~ /(_id|^id)$/ || (v.first.to_s == v.last.to_s)
    end
  end

  private

  def unwanted_attributes
    [:created_at, :updated_at, "created_at", "updated_at"]
  end
end
