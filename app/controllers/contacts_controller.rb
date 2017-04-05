class ContactsController < ApplicationController

  include ReactOnRails::Controller

  before_action :load_contact, only: [
    :destroy,
    :destroy_from_grader,
    :edit,
    :edit_contact_correspondence,
    :edit_contact_details,
    :edit_contact_work_info,
    :grade,
    :set_grade,
    :show,
    :update,
    :nylas_report_info
  ]
  before_action :load_contacts, only: [:index, :search_contacts]
  before_action :set_graded_contacts, only: [
    :destroy_from_grader,
    :rank,
    :top_contact
  ]

  def index
    if params[:page]
      session[:contact_index_page] = params[:page]
    else
      session[:contact_index_page] = nil
    end
    # add_breadcrumb "Contacts", :contacts_path
    render
    session[:referring_page] = contacts_path
  end

  def ui_index
    @contacts = Contact.limit(200)
    @contacts_json_string = render_to_string(
      template: "/contacts/index.json.jbuilder",
      format: :json
    )
    # redux_store("contactsStore", props: contacts_json_string)
    respond_to do |format|
      format.html { render layout: "ux" }
    end
  end

  def search
    @contact = Contact.search(params[:query])
    if request.xhr?
      render json: @songs.to_json
    else
      render :ui_index
    end
  end

  def show
    @commentable = @contact
    @comments = @commentable.comments
    @comment = Comment.new
    @contact_activities  = @contact.contact_activities.order('completed_at desc')
    @contacts_page_url = request.referer || contacts_path
    @not_completed_tasks = @contact.tasks.not_completed.order('due_date_at asc')
    @completed_tasks = @contact.tasks.completed.order('completed_at desc')
    @phone_numbers = @contact.phone_numbers
    @email_addresses = @contact.email_addresses

    activities
  end

  def edit
    @contact.addresses.build       if @contact.addresses.blank?
    @contact.phone_numbers.build   if @contact.phone_numbers.blank?
    @contact.email_addresses.build if @contact.email_addresses.blank?
    render
  end

  def update
    @inline_form = params[:inline_form]
    respond_to do |format|
      if @contact.update(contact_params)
        @phone_numbers = @contact.phone_numbers
        @email_addresses = @contact.email_addresses

        Util.without_tracking do
          current_user.tag(@contact, :with => params[:contact_tag_list], :on => :contact_groups)
        end
        if params[:btn_save_and_add_another]
          format.html { redirect_to new_contact_path, notice: "Contact successfully updated!" }
          format.json { head :no_content }
          format.js
        else
          format.html { redirect_to session[:referring_page], notice: 'Contact was successfully updated.' }
          format.json { head :no_content }
          format.js
        end
      else
        @phone_numbers = @contact.phone_numbers
        @email_addresses = @contact.email_addresses
        format.html { flash.now[:danger] = "Please check your entry and try again."
                         render :edit
                       }
        format.json { render json: @lead.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  def new
    @contact = current_user.contacts.new
    @contact.addresses.build
    @contact.phone_numbers.build
    @contact.email_addresses.build
    session[:referring_page] = request.referer
  end

  def create
    @contact = Contact.new(contact_params)
    @contact.user            = current_user
    @contact.created_by_user = current_user
    @modal_id                = params[:modal_id]
    @target_select_id        = params[:target_select_id]
    @for_page                = params[:for_page]

    respond_to do |format|
      if @contact.save
        format.html {
          current_user.mark_initial_setup_done!
          current_user.tag(@contact, :with => params[:contact_tag_list], :on => :contact_groups)
          if params[:btn_save_and_add_another]
            redirect_to new_contact_path, notice: "Contact successfully created!"
          else
            redirect_to session[:referring_page] || @contact, notice: "Contact successfully created!"
          end
        }
        format.js
      else
        flash.now[:danger] = "Please check your entry and try again."
        format.html {
          render :new
        }
        format.js
      end
    end
  end

  def destroy
    @contact.mark_as_inactive!
    redirect_path = request.referer.present? ? request.referer : contacts_path
    redirect_to redirect_path
  end

  def destroy_from_grader
    @contact.mark_as_inactive!
    set_ungraded_current_contact
    current_user.reload
    render "grade", layout: false
  end

  def destroy_multiple
    Contact.transaction do
      if params[:ids]
        params[:ids].each do |id|
          current_user.contacts.find(id).mark_as_inactive!
        end
      end
    end

    respond_to do |format|
      format.html { redirect_to contacts_url }
      format.json { head :no_content }
    end
  end

  def postponecall
    @contact = Contact.find(params[:contact_id])
    @contact.next_call_at = Time.zone.now.beginning_of_day + 7.days
    @contact.save!
    redirect_to marketing_center_index_path, notice: "Activity successfully postponed!"
  end

  def postponenote
    @contact = Contact.find(params[:contact_id])
    @contact.next_note_at = Time.zone.now.beginning_of_day + 7.days
    @contact.save!
    redirect_to marketing_center_index_path, notice: "Activity successfully postponed!"
  end

  def postponevisit
    @contact = Contact.find(params[:contact_id])
    @contact.next_visit_at = Time.zone.now.beginning_of_day + 7.days
    @contact.save!
    redirect_to marketing_center_index_path, notice: "Activity successfully postponed!"
  end

  def rank
    set_ungraded_current_contact
  end

  def set_grade
    if @contact.update_attributes(grade: params[:grade_id], graded_at: Time.current)
      redirect_to contact_path(@contact), notice: 'Successfully updated contact grade.'
    else
      redirect_to contact_path(@contact), notice: 'Error updating grade..'
    end
  end

  def top_contact
    if params[:current_contact_id]
      if @current_contact = current_user.contacts.active.find_by(id: params[:current_contact_id])
      else
        set_ungraded_current_contact
      end
    else
      set_ungraded_current_contact
    end
  end

  def top_contact_autocomplete
    @contacts = current_user.contacts.active.ungraded.search_name(params[:search_term])
    search_results = []
    @contacts.to_a.each do |contact|
      search_results << {value: contact.full_name, url: top_contact_path({current_contact_id: contact.id})}
    end
    render json: search_results
  end

  def grade
    if @contact.update_attributes grade: params[:grade_id], graded_at: Time.current
      current_user.mark_initial_setup_done!
      @graded_contacts = current_user.contacts.active.graded.order(graded_at: :desc).limit(10).to_a
      set_ungraded_current_contact
      current_user.reload # User object becomes stale after contact related updates.
      @contact_graded_message = "Successfully graded contact #{@contact.full_name}."
      render "grade", layout: false
    else
      render json: { notice: "Failed to rank contact."}, status: :unprocessable_entity and return
    end
  end

  def search_contacts
    if params[:page]
      session[:contact_index_page] = params[:page]
    else
      session[:contact_index_page] = nil
    end
    render layout: false
  end

  def autocomplete_group_tags
    tags = ActsAsTaggableOn::Tagging.where("taggings.tagger_id = ? AND taggings.context = ? AND tags.name like ?", current_user.id, :contact_groups, "#{params[:term]}%").joins(:tag).select('DISTINCT tags.name').map{ |x| x.name}
    json_tags = []
    tags.each do |tag|
      json_tags << { label: tag}
    end
    render json: json_tags
  end

  def edit_contact_details
    @contact.addresses.build       if @contact.addresses.blank?
    @contact.phone_numbers.build   if @contact.phone_numbers.blank?
    @contact.email_addresses.build if @contact.email_addresses.blank?

    session[:referring_page] = request.referer
  end

  def edit_contact_correspondence
    session[:referring_page] = request.referer
  end

  def edit_contact_work_info
    session[:referring_page] = request.referer
  end

  def refresh_fullcontact_info
    contact = Contact.find(params[:id])
    lead = Lead.find(params[:lead_id]) if params[:lead_id]
    contact.refresh_contact_api_info
    redirect_object = lead || contact
    if Contact.find(params[:id]).search_status == "Our API has found some information about this person"
      redirect_to redirect_object, notice: "Social info has been updated"
    else
      redirect_to redirect_object, warning: "A search is either currently in progress, or no social info was found. Check again in a few minutes."
    end
  end

  def email_campaigns_sent
    @contact = Contact.find(params[:id])
    @campaigns = MandrillMessage.where(contact_id: @contact.id)
    render
  end

  def fetch_address_with_jquery
    contact_id = params[:contact_id]
    contact = Contact.find(contact_id)
    address_string = create_contact_address_string(contact)
    respond_to do |format|
      format.json { render json: address_string }
    end
  end

  def open_contact_modal
    @contact = Contact.new
    @contact.addresses.build
    @contact.phone_numbers.build
    @contact.email_addresses.build
    @modal_id = params[:modal_id]
    @target_select_id = params[:target_select_id]
    @for_page = params[:for_page]
  end

  def nylas_report_info
    render layout: false
  end

  private

  def activities
    @activities          = @contact.recent_activities(page: params[:activity_feed_page])
    @activities_link_url = recent_activities_path(activities_owner_id: @contact.id,
                                                  activities_owner_type: "Contact",
                                                  activity_feed_page: @activities.next_page)
  end

  def contact_params
    params.require(:contact).permit(
      :name,
      :first_name,
      :last_name,
      :spouse_first_name,
      :spouse_last_name,
      :user_id,
      :grade,
      :envelope_salutation,
      :letter_salutation,
      :company,
      :profession,
      :title,
      :last_note_sent_at,
      :next_note_at,
      :last_called_at,
      :next_call_at,
      :last_visited_at,
      :next_visit_at,
      :require_base_validations,
      :require_basic_validations,
      addresses_attributes: [
        :id,
        :address,
        :city,
        :state,
        :zip,
        :street
      ],
      phone_numbers_attributes: [
        :id,
        :number,
        :number_type,
        :primary,
        :_destroy
      ],
      email_addresses_attributes: [
        :id,
        :email,
        :email_type,
        :primary,
        :_destroy
      ])
  end

  def load_contact
    @contact = Contact.find(params[:id])
  end

  def load_contacts
    search_contacts = if params[:search_term].present?
                        current_user.contacts.search_name(params[:search_term])
                      else
                        current_user.contacts
                      end

    group = params[:group]

    if group and group != 'all'
      search_contacts = search_contacts.tagged_with(group)
    end

    grade = params[:grade]

    if grade and grade != "all"
      case grade
        when "graded"
          search_contacts = search_contacts.graded
        when "ungraded"
          search_contacts = search_contacts.ungraded
        when "aplus_abc"
          search_contacts = search_contacts.grad_a_plus_abc
        when "aplus"
          search_contacts = search_contacts.grad_a_plus
      end
    end

    order_by = params[:order_by] || "first_name"
    sort_direction = params[:sort_direction] || "asc"

    @contacts = search_contacts.active.order("#{order_by} #{sort_direction}").page(params[:page])

  end

  def set_ungraded_current_contact
    @current_contact = current_user.contacts.active.random_ungraded_contact params[:dont_rank]
  end

  def set_graded_contacts
    @graded_contacts = current_user.contacts.active.graded.order(graded_at: :desc).limit(10).to_a
  end

  def create_contact_address_string(contact)
    address = contact.primary_address
    address_string = ""
    if address

      if address.street
        address_string += " present *****"
        address_string += " #{address.street} *****"
      else
        address_string += " nopresence *****"
        address_string += " EMPTY *****"
      end

      if address.city
        address_string += " present *****"
        address_string += " #{address.city} *****"
      else
        address_string += " nopresence *****"
        address_string += " EMPTY *****"
      end

      if address.state
        address_string += " present *****"
        address_string += " #{address.state} *****"
      else
        address_string += " nopresence *****"
        address_string += " EMPTY *****"
      end

      if address.zip
        address_string += " present *****"
        address_string += " #{address.zip} *****"
      else
        address_string += " nopresence *****"
        address_string += " EMPTY *****"
      end

    end
    address_string
  end

end
