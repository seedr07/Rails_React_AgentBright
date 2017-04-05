class TaskCarrier

  # Why we should use carrier, please check this
  # http://blog.bigbinary.com/2014/12/02/drying-up-rails-views-with-view-carriers-and-services.html

  attr_reader :task

  def initialize(task)
    @task = task
  end

  def handle_display_style(value)
    "display:#{task.taskable_type == value ? 'block' : 'none'}"
  end

  def set_checked_radio_button_for_associated
    return "None" if task.new_record? || task.taskable == nil
    return "Lead/Client" if task.taskable_type == "Lead"

    task.taskable_type
  end

  def showable_set_next_action_modal?(from_page, incomplete_tasks)
    from_page == "home-index" && incomplete_tasks.blank?
  end

end
