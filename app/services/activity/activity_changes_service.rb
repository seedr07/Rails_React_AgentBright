class Activity::ActivityChangesService

  attr_reader :activity

  def initialize(activity)
    @activity = activity
  end

  def activity_changes(&block)
    model = activity.trackable_type.constantize

    activity_updates.map do |attr, v|
      attribute_title = model.human_attribute_name(attr)
      from = normalize_attrs_value(v.first)
      to = normalize_attrs_value(v.last)
      block.call(attribute_title, from, to)
    end.join(' ')
  end

  def activity_updates
    return nil if activity.parameters[:changes].nil?

    unless activity.parameters[:changes].is_a? String
      activity_changes = activity.parameters[:changes]
      Activity::UnwantedChangesRemoverService.new(activity_changes).perform
    end
  end

  private

  def normalize_attrs_value(val)
    val.to_s.strip.humanize
  end

end
