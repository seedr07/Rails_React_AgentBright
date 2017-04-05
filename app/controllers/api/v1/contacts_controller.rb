class Api::V1::ContactsController < Api::V1::BaseController

  def index
    @contacts = Contact.limit(500)

    if @contacts
      # render json: @contacts
      render "contacts/index"
    else
      respond_with_error("Contacts not found.", :not_found)
    end
  end

end
