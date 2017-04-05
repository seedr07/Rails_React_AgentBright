require "test_helper"
require "datetime_formatting_helper"

class TasksHelperTest < ActionView::TestCase

  include DatetimeFormattingHelper
  fixtures :users, :contacts, :tasks, :leads, :teammates, :teams

  def setup
    @nancy_user = users(:nancy)
    @task_one = tasks(:one)
    @task_two = tasks(:two)
    @task_incomplete = tasks(:incomplete)
    @task_nancy_task1 = tasks(:nancy_task1)
    @katie_lead = leads(:katie)
  end

  def test_link_to_associated_record
    assert_equal(
      "<a href=\"/contacts/501661262\">Will O&#39;Smith (Contact)</a>",
      link_to_associated_record(@task_one)
    )
    assert_equal(
      "<a href=\"/leads/826647699\">Katie Lozar0 - Client (Lead)</a>",
      link_to_associated_record(@task_two)
    )
    @task_two.update_columns(taskable_type: "Client")
    assert_equal(
      "<a href=\"/leads/826647699\">Katie Lozar0 - Client (Client)</a>",
      link_to_associated_record(@task_two)
    )
    @task_two.reload.update_columns(taskable_type: "User", taskable_id: @nancy_user.id)
    assert_equal(
      "<a href=\"/users/#{@nancy_user.id}\">User ##{@nancy_user.id}</a>",
      link_to_associated_record(@task_two)
    )
  end

  def test_show_assigned_to
    assert_equal "Nancy Smith", show_assigned_to(@task_nancy_task1)
  end

  def test_show_taskable
    assert_equal "Will O'Smith (Contact)", show_taskable(@task_one)
    assert_equal "Katie Lozar0 - Client (Client)", show_taskable(@task_two)
  end

  def test_show_taskable_lead_with_status_of_0
    @task_two.taskable.update_columns(status: 0)
    assert_equal "Katie Lozar0 - Client (Lead)", show_taskable(@task_two)
  end

  def test_show_taskable_link
    assert_equal(
      "<a class=\"small-meta fwb\" href=\"/leads/#{@task_nancy_task1.taskable.id}\">Lozar - Buyer (Client)</a>",
      show_taskable_link(@task_nancy_task1)
    )
  end

  def test_show_taskable_link_for_contact
    assert_equal(
      "<a class=\"small-meta fwb\" href=\"/contacts/#{@task_one.taskable.id}\">Will O&#39;Smith (Contact)</a>",
      show_taskable_link(@task_one)
    )
  end

  def test_show_taskable_link_lead_with_status_of_0
    @task_nancy_task1.taskable.update_columns(status: 0)
    assert_equal(
      "<a class=\"small-meta fwb\" href=\"/leads/#{@task_nancy_task1.taskable.id}\">Lozar - Buyer (Lead)</a>",
      show_taskable_link(@task_nancy_task1)
    )
  end

  def test_todo_completed_class
    assert_equal "completed", todo_completed_class(@task_nancy_task1)
  end

  def test_todo_overdue_class
    assert_equal "overdue", todo_overdue_class(@task_incomplete)
  end

  def test_user_and_teammate_array
    assert_equal 1, user_and_teammate_array(@nancy_user).count
  end

  def test_display_number_of_tasks_create_and_completed_since_yesterday
    travel_to(Time.current.end_of_day)
    Lead.any_instance.stubs(:number_of_tasks_created_since_yesterday).returns(1)
    Util.log "number_of_tasks_created_since_last_week: #{@katie_lead.number_of_tasks_created_since_last_week}"
    assert_equal(
      "1 task was added:",
      display_number_of_tasks_create_and_completed_since_yesterday(@katie_lead)
    )
    Lead.any_instance.stubs(:number_of_tasks_completed_since_yesterday).returns(10)
    assert_equal(
      "1 task was added and 10 tasks were completed:",
      display_number_of_tasks_create_and_completed_since_yesterday(@katie_lead)
    )
  end

  def test_display_number_of_tasks_create_and_completed_since_last_week
    travel_to(Time.current.end_of_day)
    Lead.any_instance.stubs(:number_of_tasks_created_since_last_week).returns(1)
    assert_equal(
      "1 task was added:",
      display_number_of_tasks_create_and_completed_since_last_week(@katie_lead)
    )
    Lead.any_instance.stubs(:number_of_tasks_completed_since_last_week).returns(10)
    assert_equal(
      "1 task was added and 10 tasks were completed:",
      display_number_of_tasks_create_and_completed_since_last_week(@katie_lead)
    )
  end

  def test_task_pill_contents
    assert_equal "Nancy Smith · 12/28/15", task_pill_contents(@task_nancy_task1)
  end

end
