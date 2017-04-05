module ActivitiesHelper

  def activities_by_day(activities)
    activities.group_by { |activity| activity.created_at.strftime("%A, %B %-d") }
  end

  def activity_icon(color_class, icon)
    render(
      partial: "activities/activity_icon",
      locals: { color_class: color_class, icon: icon }
    )
  end

  def activity_creator(activity)
    content_tag(
      :span,
      display_owner_name_if_owner_exists(activity),
      class: "creator"
    )
  end

  def activity_subject(activity, options={})
    render(
      partial: "activities/activity_subject",
      locals: options.merge(activity: activity)
    )
  end

  def activity_bucket(activity, preposition, bucket_name, bucket_link=nil)
    if activity.recipient_id.present?
      render(
        partial: "activities/activity_bucket",
        locals: {
          preposition: preposition,
          bucket_name: bucket_name,
          bucket_link: bucket_link
        }
      )
    end
  end

  def activity_excerpt(activity, changes_partial="changes")
    render(
      partial: "activities/activity_excerpt",
      locals: { activity: activity, changes_partial: changes_partial }
    )
  end

  def created_activity_excerpt(activity, changes_partial="created")
    render(
      partial: "activities/activity_excerpt",
      locals: { activity: activity, changes_partial: changes_partial }
    )
  end

  def recipient_name(activity)
    recipient = activity.recipient

    if recipient
      recipient.name
    else
      "a deleted record"
    end
  end

  def activity_link(recipient)
    if recipient
      polymorphic_url(recipient)
    end
  end

  def showable_new_activity_stream?(controller_name, action_name)
    controller_names = %w(contacts leads)
    action_names     = %w(show show_lead)

    if controller_names.include?(controller_name) && action_names.include?(action_name)
      return true
    end

    false
  end

  def human_activity_name(activity)
    name = activity.parameters[:name]

    name ||= activity.trackable.name if activity.trackable.respond_to?(:name)
    name ||= "##{activity.trackable_id}" # if there is no name return string like '#44'

    underscored?(name) ? name.to_s.humanize : name
  end

  def activity_stream_cache_helper(activities_grouped_by_date)
    activities_grouped_by_date.map { |_date, activities| activities.map(&:id) }.flatten
  end

  private

  def display_owner_name_if_owner_exists(activity)
    if activity.owner
      show_you_if_owner_is_current_user(activity)
    else
      "AgentBright"
    end
  end

  def show_you_if_owner_is_current_user(activity)
    if activity.owner == current_user
      "You"
    else
      activity.owner.first_name
    end
  end

end
