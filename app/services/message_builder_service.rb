class MessageBuilderService
  attr_reader :_to, :_cc, :_bcc, :_subject, :_body, :user

  EMAIL_REGEX = /\A\S+@.+\.\S+\z/

  def initialize(to: "", cc: "", bcc: "", subject: "", body: "", user:)
    @_to          = to.split(",")
    @_cc          = cc.split(",")
    @_bcc         = bcc.split(",")
    @_subject     = subject
    @_body        = body
    @email_errors = []
    @user         = user
  end

  def process
    to
    cc
    bcc
    subject
    body
    has_email_errors?

    self
  end

  def to
    return @to_data unless @to_data.nil?

    @to_data = []

    @_to.each do |email|
      @to_data << recipient_data_for(email)
    end

    @to_data
  end

  def cc
    return @cc_data unless @cc_data.nil?

    @cc_data = []

    @_cc.each do |email|
      @cc_data << recipient_data_for(email)
    end

    @cc_data
  end

  def bcc
    return @bcc_data unless @bcc_data.nil?

    @bcc_data = []

    @_bcc.each do |email|
      @bcc_data << recipient_data_for(email)
    end

    @bcc_data
  end

  def subject
    # Subject should not be empty
    if @_subject.blank?
      @email_errors << true
    end

    @_subject
  end

  def body
    @_body
  end

  def has_email_errors?
    !@email_errors.blank?
  end

  private

  def valid_email?(email)
    !!(email =~ EMAIL_REGEX)
  end

  def recipient_data_for(email)
    contact = find_contact_for(email)
    if contact.present?
      { name: contact.name, email: email }
    else
      if valid_email?(email)
        { name: "", email: email }
      else
        @email_errors << true

        return nil
      end
    end
  end

  def find_contact_for(email)
    user.contact_email_addresses.where(email: email).collect(&:owner).first
  end

end
