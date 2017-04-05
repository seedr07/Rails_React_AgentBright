class UserSettings::LeadEmailsController < ApplicationController

  before_action :set_lead, only: [:show]
  before_action :authenticate_superadmin_user!

  def index
    @lead_emails = LeadEmail.page(params[:page]).order("created_at desc").load
    @all_lead_emails = LeadEmail.all
    @today_emails = @all_lead_emails.where("created_at >= ?", Time.zone.now - 24.hours)
    @week_emails = @all_lead_emails.where("created_at >= ?", Time.zone.now - 7.days)
    @month_emails = @all_lead_emails.where("created_at >= ?", Time.zone.now - 30.days)
  end

  def show
    @lead_email = LeadEmail.find(params[:id])
    @lead_email_html_string = @lead_email.html.to_s
    render
  end

  def set_lead
    @lead_email = LeadEmail.find(params[:id])
  end

end
