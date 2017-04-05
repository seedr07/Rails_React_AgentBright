module ActivityWatcher
  # This method will return true only if activty parameters changes are blank or
  # it has only one 'updated_at' parameter change.
  def savable_activity?(activity_changes)
    activity_changes = Activity::UnwantedChangesRemoverService.new(activity_changes).
                                                               perform
    activity_changes.keys != ["updated_at"] && activity_changes.keys != []
  end
end
