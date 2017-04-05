require "test_helper"

class ContactsControllerTest < ActionController::TestCase

  fixtures :users, :contacts

  def setup
    @will = contacts(:will)
    @jane = contacts(:jane)
    @nancy = users(:nancy)
    sign_in @nancy

    VCR.insert_cassette("contacts_controller_test")
  end

  def teardown
    VCR.eject_cassette
  end

  def test_rank_index_response
    get :rank
    assert_response :success
  end

  def test_doesnt_show_contact_if_skipped
    get :rank, params: { dont_rank: @jane.id }
    assert_not_includes response.body, @jane.full_name
  end

  def test_successfully_grades_ungraded_contact
    create_contact_named_steve_jobs
    post :grade, params: { id: @steve_jobs.id, grade_id: 1 }
    assert_response :success
    @steve_jobs.reload
    assert_equal "A", @steve_jobs.grade_to_s
  end

  def test_create_with_js
    post(
      :create,
      params: {
        contact: valid_contact_params,
        format: "js"
      },
      xhr: true
    )
    assert_response :success
    assert_equal "text/javascript", @response.content_type
  end

  def test_invalid_grade_for_contact
    assert_nil @jane.grade
    post :grade, params: { id: @jane.id, grade_id: 100 }
    assert_nil @jane.grade
  end

  def test_index_success_response
    get :index
    assert_response :success
  end

  def test_index_doesnt_fetch_inactive_contacts
    mary = create_contact
    create_contact(
      last_name: "Smith",
      first_name: "John",
      email_addresses_attributes: [
        email: "johncontact@example.com",
        email_type: "Primary"
      ]
    )
    mary.mark_as_inactive!
    get :index
    assert_response :success
    assert_not_includes response.body, "Mary"
    assert_includes response.body, "John"
  end

  def test_show_success_response
    datetime = DateTime.parse("Thu, 03 Nov 2016 04:41:28")
    Timecop.freeze(datetime) do
      get :show, params: { id: @will.id }
    end
    assert_response :success
  end

  def test_new
    get :new
    assert_response :success
  end

  def test_edit
    get :edit, params: { id: @will.id }
    assert_response :success
  end

  def test_create_contact_successfull_on_valid_input
    session[:referring_page] = contacts_path
    assert_difference "Contact.count" do
      post :create, params: { contact: valid_contact_params }
    end
    blair = Contact.last
    assert_redirected_to session[:referring_page]
    assert_equal "Mike Smith", blair.full_name
    assert_equal "A", blair.grade_to_s
    assert_equal "MS", blair.initials
  end

  def test_button_save_and_add_another
    session[:referring_page] = contacts_path
    assert_difference "Contact.count" do
      post :create, params: { contact: valid_contact_params, btn_save_and_add_another: true }
    end
    assert_redirected_to new_contact_path
    assert_equal "Contact successfully created!", flash[:notice]
  end

  def test_update_contact_successfull_on_valid_input
    session[:referring_page] = contacts_path
    post(
      :update,
      params: {
        id: @will.id,
        contact: valid_contact_params.merge(email: "blair@example.com")
      }
    )
    assert_redirected_to session[:referring_page]
    @will.reload
    assert_equal "Mike Smith", @will.full_name
  end

  def test_update_contact_successfull_and_save_add_another
    post(
      :update,
      params: {
        id: @will.id,
        contact: valid_contact_params.merge(email: "blair@example.com"),
        btn_save_and_add_another: "true"
      }
    )
    assert_redirected_to new_contact_path
    @will.reload
    assert_equal "Mike Smith", @will.full_name
  end

  def test_update_contact_failure
    post(
      :update,
      params: {
        id: @will.id,
        contact: valid_contact_params.merge(email: "blair@example.com", grade: 10)
      }
    )
    assert_equal "Please check your entry and try again.", flash[:danger]
  end

  def test_create_contact_unsuccessfull_without_valid_input_params
    assert_no_difference "Contact.count" do
      post :create, params: { contact: invalid_contact_params }
    end
    assert_response :success
    assert_equal "Please check your entry and try again.", flash[:danger]
  end

  def test_mark_contact_as_inactive
    mary = create_contact
    assert_equal "Mary Smith", mary.full_name
    assert_difference "Contact.active.count", -1 do
      delete :destroy, params: { id: mary.id }
    end
    mary.reload
    assert_not_nil mary.inactive_at
  end

  def test_mark_contact_inactive_from_contacts_grader
    mary = create_contact
    assert_equal "Mary Smith", mary.full_name
    assert_difference "Contact.active.count", -1 do
      delete :destroy_from_grader, params: { id: mary.id }
    end
    mary.reload
    assert_not_nil mary.inactive_at
  end

  def test_destroy_multiple
    @will.update_columns(user_id: @nancy.id)
    @jane.update_columns(user_id: @nancy.id)
    post :destroy_multiple, params: { ids: [@will.id, @jane.id] }
    @will.reload
    @jane.reload
    assert_equal @will.active, false
    assert_equal @jane.active, false
  end

  def test_top_contact_autocomplete
    mary = create_contact
    get :top_contact_autocomplete, params: { search_term: "m" }
    content = JSON.parse(response.body)
    assert_equal 1, content.size
    search_result_contact = content.first
    assert_equal mary.full_name, search_result_contact["value"]
    assert_equal(
      top_contact_path(current_contact_id: mary.id),
      search_result_contact["url"]
    )
  end

  def test_top_contact_autocomplete_doesnt_fetch_inactive_records
    mary = create_contact
    create_contact(
      last_name: "Smith",
      first_name: "John",
      email_addresses_attributes: [
        email: "johncontact@example.com",
        email_type: "Primary"
      ]
    )
    mary.mark_as_inactive!
    mary.reload
    get :top_contact_autocomplete, params: { search_term: "s" }
    content = JSON.parse(response.body)
    assert_equal 1, content.size
    assert_not_includes response.body, "Mary"
    assert_includes response.body, "John"
  end

  def test_email_campaigns_sent_success
    get :email_campaigns_sent, params: { id: @will.id }
    assert_response :success
  end

  def test_postpone_call
    get :postponecall, params: { contact_id: @will.id }
    assert_redirected_to marketing_center_index_path
  end

  def test_postpone_note
    get :postponenote, params: { contact_id: @will.id }
    assert_redirected_to marketing_center_index_path
  end

  def test_postpone_visit
    get :postponevisit, params: { contact_id: @will.id }
    assert_redirected_to marketing_center_index_path
  end

  def test_set_grade
    create_contact_named_steve_jobs
    get :set_grade, params: { id: @steve_jobs.id, grade_id: 1, graded_at: Time.current }
    assert_redirected_to contact_path(@steve_jobs)

    get :set_grade, params: { id: @steve_jobs.id, grade_id: 100, graded_at: Time.current }
    assert_redirected_to contact_path(@steve_jobs)
    assert_equal "Error updating grade..", flash[:notice]
  end

  def test_top_contacts
    get :top_contact
    assert_response :success
  end

  def test_search_contacts
    get :search_contacts, params: { search_term: "m" }
    assert_response :success
  end

  def test_edit_contact_details
    create_contact_named_steve_jobs
    session[:referring_page] = contacts_path
    get(
      :edit_contact_details,
      params: { id: @steve_jobs.id, format: "js" },
      xhr: true
    )
    assert_response :success
    assert_equal "text/javascript", @response.content_type
  end

  def test_edit_contact_correspondence
    create_contact_named_steve_jobs
    session[:referring_page] = contacts_path
    get(
      :edit_contact_correspondence,
      params: { id: @steve_jobs.id, format: "js" },
      xhr: true
    )
    assert_response :success
    assert_equal "text/javascript", @response.content_type
  end

  def test_edit_contact_work_info
    create_contact_named_steve_jobs
    session[:referring_page] = contacts_path
    get(
      :edit_contact_work_info,
      params: { id: @steve_jobs.id, format: "js" },
      xhr: true
    )
    assert_response :success
    assert_equal "text/javascript", @response.content_type
  end

  def test_email_campaigns_sent
    create_contact_named_steve_jobs
    session[:referring_page] = contacts_path
    get(:email_campaigns_sent, params: { id: @steve_jobs.id })
    assert_response :success
  end

  def test_fetch_address_with_jquery
    create_contact_named_steve_jobs
    session[:referring_page] = contacts_path
    get(
      :fetch_address_with_jquery,
      params: { contact_id: @steve_jobs.id, format: "json" },
      xhr: true
    )
    assert_response :success
    assert_equal "application/json", @response.content_type
  end

  def test_open_contact_modal
    get :open_contact_modal, xhr: true
    assert_response :success
  end

  def test_nylas_report_info_success
    @jane = users(:jane)
    @beth = contacts(:beth)

    sign_in @jane

    datetime = DateTime.parse("Thu, 03 Nov 2016 04:41:28")
    Timecop.freeze(datetime) do
      get :nylas_report_info, params: { id: @beth.id },  xhr: true
    end
    assert_response :success
  end

  private

  def create_contact(options={})
    Contact.create!(
      {
        user: @nancy,
        created_by_user: @nancy,
        last_name: "Smith",
        first_name: "Mary",
        addresses_attributes: {
          "0" => {
            address: "342 W",
            street: "60th St.",
            city: "Philadelphia",
            state: "PA", zip: "29810"
          }
        },
        phone_numbers_attributes: [number: "860-227-3414", number_type: "Mobile"],
        email_addresses_attributes: [email: "mary@exapmle.com", email_type: "Primary"]
      }.merge(options)
    )
  end

  def create_contact_named_steve_jobs
    @steve_jobs = Contact.create!(
      user: @nancy,
      created_by_user: @nancy,
      last_name: "Jobs",
      first_name: "Steve",
      addresses_attributes: {
        "0" => {
          address: "342 W",
          street: "60th St.",
          city: "Philadelphia",
          state: "PA",
          zip: "29810"
        }
      },
      phone_numbers_attributes: [number: "860-227-3414", number_type: "Mobile"]
    )
  end

  def valid_contact_params
    {
      first_name: "Mike",
      last_name: "Smith",
      spouse: "Jane Smith",
      grade: "1",
      email_addresses_attributes: [email: "mike@example.com", email_type: "Primary"],
      phone_numbers_attributes: [number: "214-454-5604", number_type: "Mobile"],
      addresses_attributes: {
        "0" => {
          address: "342 W",
          street: "60th St.",
          city: "Philadelphia",
          state: "PA",
          zip: "29810"
        }
      },
      envelope_salutation: "Mr.",
      letter_salutation: "Mr.",
      company: "Baker Gauges Inc.",
      profession: "Techinician.",
      title: "Manager.",
      user_id:  @nancy.id
    }
  end

  def invalid_contact_params
    { grade: "100001" }
  end

end
