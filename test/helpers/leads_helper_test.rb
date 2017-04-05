require "test_helper"
require "application_helper"
require "contacts_helper"
require "datetime_formatting_helper"

class LeadsHelperTest < ActionView::TestCase

  include ApplicationHelper
  include ContactsHelper
  include DatetimeFormattingHelper

  fixtures :leads, :comments, :users, :contacts

  def setup
    @nancy_user = users(:nancy)
    @katie_lead = leads(:katie)
    VCR.insert_cassette("leads_helper_test")
  end

  def teardown
    VCR.eject_cassette
  end

  def test_display_as_lead
    @katie_lead.update_columns(status: 0)
    assert_equal true, display_as_lead?(@katie_lead)
  end

  def test_display_as_client
    @katie_lead.update_columns(status: 1)
    assert_equal true, display_as_client?(@katie_lead)
  end

  def test_display_text_status
    @katie_lead.update_columns(status: 0)
    assert_equal "lead", display_text_status(@katie_lead)
    @katie_lead.reload.update_columns(status: 1)
    assert_equal "client", display_text_status(@katie_lead)
  end

  def test_display_lead_price_range
    assert_equal "Not Set", display_lead_price_range(@katie_lead)
    @katie_lead.reload.update_columns(min_price_range: 100000, max_price_range: 200000)
    assert_equal "$100-$200k", display_lead_price_range(@katie_lead)
    @katie_lead.reload.update_columns(min_price_range: 1000000, max_price_range: 2000000)
    assert_equal "$1.0-$2.0m", display_lead_price_range(@katie_lead)
    @katie_lead.reload.update_columns(min_price_range: 100000, max_price_range: 1000000)
    assert_equal "$100k-$1.0m", display_lead_price_range(@katie_lead)
    @katie_lead.reload.update_columns(min_price_range: nil, max_price_range: 200000)
    assert_equal "up to $200k", display_lead_price_range(@katie_lead)
    @katie_lead.reload.update_columns(min_price_range: nil, max_price_range: 2000000)
    assert_equal "up to $2.0m", display_lead_price_range(@katie_lead)
  end

  def test_time_active
    assert_equal "Not Set", time_active(@katie_lead)
    @katie_lead.reload.update_columns(status: 2, original_list_date_at: Time.current - 1.day)
    assert_equal "1 day", time_active(@katie_lead)

    @katie_lead.reload.update_columns(
      status: 4,
      original_list_date_at: Time.current - 2.days,
      displayed_closing_date_at: Time.current - 1.day
    )
    assert_equal "1 day", time_active(@katie_lead)

    @katie_lead.reload.update_columns(
      status: 4,
      original_list_date_at: Time.current - 1.day,
      displayed_closing_date_at: nil
    )
    assert_equal "-", time_active(@katie_lead)

    @katie_lead.reload.update_columns(status: 1, original_list_date_at: Time.current - 1.day)
    assert_equal "-", time_active(@katie_lead)
  end

  def test_time_since_received
    travel_to(Time.current)
    @katie_lead.update_columns(incoming_lead_at: Time.current - 14.days)
    assert_equal "14 days ago", time_since_received(@katie_lead)
    @katie_lead.reload.update_columns(incoming_lead_at: nil)
    assert_equal " - ", time_since_received(@katie_lead)
  end

  def test_display_lead_status_label
    assert_equal "<div class=\"data inline-block float-left tlg\">
        <h3><span class=\"label label-danger\"><strong>Unclaimed</strong></span></h3>
      </div><!-- /data -->",
                 display_lead_status_label(@katie_lead)
    @katie_lead.reload.update_columns(state: nil)
    assert_equal "", display_lead_status_label(@katie_lead)
    @katie_lead.reload.update_columns(state: "claimed")
    assert_equal "<div class=\"data inline-block float-left tlg\">
        <h3><span class=\"label label-success\"><strong>Claimed</strong></span></h3>
      </div><!-- /data -->",
                 display_lead_status_label(@katie_lead)
  end

  def test_display_header_type
    assert_equal "Seller Prospect", display_header_type(@katie_lead)
    @katie_lead.reload.update_columns(status: 0)
    assert_equal "Seller Lead", display_header_type(@katie_lead)
    @katie_lead.reload.update_columns(status: 1)
    assert_equal "Seller Prospect", display_header_type(@katie_lead)
    @katie_lead.reload.update_columns(status: 2)
    assert_equal "Seller Client", display_header_type(@katie_lead)
    @katie_lead.reload.update_columns(status: 5)
    assert_equal "Paused Seller - N/A", display_header_type(@katie_lead)
    @katie_lead.reload.update_columns(status: 6)
    assert_equal "Not Converted Seller - N/A", display_header_type(@katie_lead)
    @katie_lead.reload.update_columns(status: 7)
    assert_equal "Junk Seller Lead", display_header_type(@katie_lead)
    @katie_lead.reload.update_columns(status: 8)
    assert_equal "Long Term Prospect Seller ", display_header_type(@katie_lead)
  end

  def test_display_index_button_type
    assert_equal "lead_all", display_index_button_type(true, @katie_lead)
    assert_equal "current_pipeline", display_index_button_type(false, @katie_lead)
    assert_equal "long_term_prospect", display_index_button_type(false, "8")
  end

  def test_display_label_on_button_type
    assert_equal "All", display_label_on_button_type(true, "3")
    assert_equal "Current Pipeline", display_label_on_button_type(false, "4")
    @katie_lead.reload.update_columns(status: 8)
    assert_equal "Long Term Prospects", display_label_on_button_type(false, "8")
  end

  def test_contacted_status_to_color
    assert_equal "danger", contacted_status_to_color(@katie_lead)
    @katie_lead.reload.update_columns(contacted_status: 0, state: "claimed")
    assert_equal "warning", contacted_status_to_color(@katie_lead)
    @katie_lead.reload.update_columns(contacted_status: 1, state: "claimed")
    assert_equal "warning", contacted_status_to_color(@katie_lead)
    @katie_lead.reload.update_columns(contacted_status: 2, state: "claimed")
    assert_equal "warning", contacted_status_to_color(@katie_lead)
    @katie_lead.reload.update_columns(contacted_status: 3, state: "claimed")
    assert_equal "success", contacted_status_to_color(@katie_lead)
    @katie_lead.reload.update_columns(contacted_status: nil, state: "claimed")
    assert_equal "neutral", contacted_status_to_color(@katie_lead)
  end

  def test_display_contact_status
    assert_equal "Unclaimed", display_contact_status(@katie_lead)
    @katie_lead.reload.update_columns(contacted_status: 0, state: "claimed")
    assert_equal "Not Contacted", display_contact_status(@katie_lead)
    @katie_lead.reload.update_columns(contacted_status: 1, state: "claimed")
    assert_equal "Attempted", display_contact_status(@katie_lead)
    @katie_lead.reload.update_columns(contacted_status: 2, state: "claimed")
    assert_equal "Awaiting Client Response", display_contact_status(@katie_lead)
    @katie_lead.reload.update_columns(contacted_status: 3, state: "claimed")
    assert_equal "Contacted", display_contact_status(@katie_lead)
    @katie_lead.reload.update_columns(contacted_status: nil, state: "claimed")
    assert_equal " - ", display_contact_status(@katie_lead)
  end

  def test_formatted_lead_name
    assert_equal "Katie Lozar", formatted_lead_name(@katie_lead)
    Contact.any_instance.stubs(:full_name).returns(nil)
    assert_equal "katie", formatted_lead_name(@katie_lead)
    Contact.any_instance.stubs(:primary_email_address).returns(nil)
    assert_equal "(01) 055-5111", formatted_lead_name(@katie_lead)
  end

  def test_elapsed_time_before_contacted
    assert_equal "1 day", elapsed_time_before_contacted(@katie_lead)
    @katie_lead.reload.update_columns(incoming_lead_at: nil)
    assert_equal " - ", elapsed_time_before_contacted(@katie_lead)
  end

  def test_display_infobar_data
    assert_equal(
      render(partial: "leads/infobars/slat_data", locals: { lead: @katie_lead }),
      display_infobar_data(@katie_lead)
    )
  end

  def test_average_lead_response_time_in_words
    assert_equal "1 day", average_lead_response_time_in_words(@nancy_user)
  end

  def test_average_lead_response_time_in_words_nil
    User.any_instance.stubs(:average_new_lead_response_time).returns(nil)
    assert_equal " - ", average_lead_response_time_in_words(@nancy_user)
  end

  def test_lead_resolved_rate_past_week
    User.any_instance.stubs(:leads_referred_or_contact_attempted_in_past_week).returns(5)
    User.any_instance.stubs(:leads_received_in_last_week).returns(8)
    assert_equal 62, lead_resolved_rate_past_week(@nancy_user)
  end

  def test_lead_resolved_rate_past_week_zero
    assert_equal 0, lead_resolved_rate_past_week(@nancy_user)
  end

  def test_lead_status_in_email
    assert_equal "This lead has not yet been claimed.", lead_status_in_email(@katie_lead, @nancy_user)
    @john = users(:john)
    @katie_lead.update_columns(user_id: @john.id, state: "claimed")
    assert_equal "This lead has been claimed by #{@katie_lead.user.name}.",
                 lead_status_in_email(@katie_lead, @nancy_user)

    @katie_lead.update_columns(state: "claimed", contacted_status: 0, user_id: @nancy_user.id)
    assert_equal "You claimed this lead.", lead_status_in_email(@katie_lead, @nancy_user)

    @katie_lead.update_columns(state: "claimed", contacted_status: 2, user_id: @nancy_user.id)
    assert_equal "You claimed this lead and responded in #{elapsed_time_before_contacted(@katie_lead)}",
                 lead_status_in_email(@katie_lead, @nancy_user)
  end

  def test_lead_recap_status_not_claimed
    assert_equal(
      "This lead has not been claimed.",
      lead_recap_status(@katie_lead, @nancy_user)
    )
  end

  def test_lead_recap_status_user_marked_junk
    @katie_lead.update_columns(
      state: "claimed",
      status: 7,
      user_id: @nancy_user.id
    )
    assert_equal(
      "You claimed this lead and marked it as junk.",
      lead_recap_status(@katie_lead, @nancy_user)
    )
  end

  def test_lead_recap_status_user_claimed_but_did_not_yet_reply
    @katie_lead.reload.update_columns(
      state: "claimed",
      status: 0,
      user_id: @nancy_user.id,
      contacted_status: 0
    )
    assert_equal(
      "You claimed this lead but have not replied yet.",
      lead_recap_status(@katie_lead, @nancy_user)
    )
  end

  def test_lead_recap_status_user_claimed_and_replied
    @katie_lead.update_columns(
      state: "claimed",
      status: 0,
      user_id: @nancy_user.id,
      contacted_status: 2
    )
    recap_service = DailyLeadsRecapService.new(@katie_lead)
    DailyLeadsRecapService.any_instance.stubs(:avg_response_time).returns(15.minutes)
    assert_equal(
      "You claimed this lead and replied in 15 minutes.",
      lead_recap_status(@katie_lead, @nancy_user, recap_service)
    )
  end

  def test_lead_recap_service_someone_else_marked_as_junk
    john = users(:john)
    john.update_columns(name: "John Smith")
    @katie_lead.update_columns(
      state: "claimed",
      status: 7,
      user_id: john.id
    )
    assert_equal(
      "John Smith claimed this lead and marked it as junk.",
      lead_recap_status(@katie_lead, @nancy_user)
    )
  end

  def test_lead_recap_status_someone_else_claimed_but_did_not_reply
    john = users(:john)
    john.update_columns(name: "John Smith")
    @katie_lead.update_columns(
      state: "claimed",
      status: 0,
      user_id: john.id,
      contacted_status: 0
    )
    assert_equal(
      "#{@katie_lead.user.name} claimed this lead but has not replied yet.",
      lead_recap_status(@katie_lead, @nancy_user)
    )
  end

  def test_lead_recap_status_someone_else_claimed_and_replied
    john = users(:john)
    john.update_columns(name: "John Smith")
    @katie_lead.update_columns(
      state: "claimed",
      status: 0,
      user_id: john.id,
      contacted_status: 2
    )
    recap_service = DailyLeadsRecapService.new(@katie_lead)
    DailyLeadsRecapService.any_instance.stubs(:avg_response_time).returns(15.minutes)
    assert_equal(
      "John Smith claimed this lead and replied in 15 minutes.",
      lead_recap_status(@katie_lead, @nancy_user, recap_service)
    )
  end

  def test_lead_recap_status_icon_success_circle
    assert_equal(
      "<img align=\"none\" height=\"35\" style=\"margin: 0px; border: 0; outline: none;
                        text-decoration: none; -ms-interpolation-mode: bicubic;
                        height: auto !important;\" width=\"35\" src=\"/images/success_circle.png\" alt=\"Success circle\" />",
      lead_recap_status_icon(@katie_lead, @nancy_user)
    )
  end

  def test_lead_recap_status_icon_warning_circle
    @katie_lead.update_columns(contacted_status: 0, user_id: users(:john).id)
    assert_equal(
      "<img align=\"none\" height=\"35\" style=\"margin: 0px; border: 0; outline: none;
                        text-decoration: none; -ms-interpolation-mode: bicubic;
                        height: auto !important;\" width=\"35\" src=\"/images/warning_circle.png\" alt=\"Warning circle\" />",
      lead_recap_status_icon(@katie_lead.reload, @nancy_user)
    )
  end

  def test_lead_recap_status_icon_alert_circle
    @katie_lead.update_columns(contacted_status: 0)
    assert_equal(
      "<img align=\"none\" height=\"35\" style=\"margin: 0px; border: 0; outline: none;
                        text-decoration: none; -ms-interpolation-mode: bicubic;
                        height: auto !important;\" width=\"35\" src=\"/images/alert_circle.png\" alt=\"Alert circle\" />",
      lead_recap_status_icon(@katie_lead.reload, @nancy_user)
    )
  end

  def test_status_board_row_highlight_class
    assert_equal "danger", status_board_row_highlight_class(@katie_lead)
  end

  def test_show_lead_header_status_color
    assert_equal "success", show_lead_header_status_color(@katie_lead)
    @katie_lead.reload.update_columns(contacted_status: 2)
    assert_equal "warning", show_lead_header_status_color(@katie_lead)
    @katie_lead.reload.update_columns(contacted_status: 0)
    assert_equal "danger", show_lead_header_status_color(@katie_lead)
  end

  def test_lead_owner_name
    ActionView::TestCase.any_instance.stubs(:current_user).returns(@nancy_user)
    assert_equal "<span class=\"fwb\">you</span>", lead_owner_name(@katie_lead)
    @john = users(:john)
    ActionView::TestCase.any_instance.stubs(:current_user).returns(@john)
    assert_equal "Nancy Smith", lead_owner_name(@katie_lead)
  end

  def test_open_leads_sorted_by_name
    open_leads_1 = open_leads_sorted_by_name(@nancy_user)
    assert_equal 8, open_leads_1.count
    assert_includes open_leads_1, @katie_lead
    @katie_lead.update_columns(status: 4)
    open_leads_2 = open_leads_sorted_by_name(@nancy_user)
    assert_equal 7, open_leads_2.count
    assert_not_includes open_leads_2, @katie_lead
  end

  def test_lead_received_time_in_words
    travel_to(Time.current)
    @katie_lead.update_columns(incoming_lead_at: Time.current - 14.days)
    Lead.any_instance.stubs(:lead_source_to_s).returns("Trulia")
    assert_equal(
      "14 days ago from <span class=\"fwb\">Trulia</span>",
      lead_received_time_in_words(@katie_lead, true)
    )
  end

  def test_lead_received_time_in_words_no_source
    travel_to(Time.current)
    @katie_lead.update_columns(incoming_lead_at: Time.current - 14.days)
    travel_to(Time.current)
    assert_equal "14 days ago", lead_received_time_in_words(@katie_lead)
  end

end
