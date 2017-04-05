class DesignsController < ApplicationController

  skip_before_action :authenticate_user!
  layout "ux"

  def email_campaigns_index
    render "designs/email_campaigns/index"
  end

  def email_campaigns_edit
    render "designs/email_campaigns/edit"
  end

  def email_campaigns_edit_basic
    render "designs/email_campaigns/edit_basic"
  end

  def onboarding_index
    render "designs/onboarding/index"
  end

  def onboarding_index_speed
    render "designs/onboarding/speed"
  end

  def contacts_index
    render "designs/contacts/index"
  end

  def contacts_edit_groups
    render "designs/contacts/edit_groups"
  end

  def contacts_recent_contacts
    render "designs/contacts/recent_contacts"
  end

  def contacts_sorting
    render "designs/contacts/sorting"
  end

end
