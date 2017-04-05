class Views::SetEmailSignatureToBodyService

  attr_reader :email_body, :user

  def initialize(email_body, user)
    @email_body = email_body
    @user       = user
  end

  def process
    if user.email_signature_status?
      "#{email_body}<br/>#{user.email_signature}"
    else
      email_body
    end
  end

end
