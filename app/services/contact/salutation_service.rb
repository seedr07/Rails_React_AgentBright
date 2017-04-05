class Contact::SalutationService

  attr_reader :first_name, :last_name, :spouse_first_name, :spouse_last_name

  def initialize(contact)
    @first_name = contact.first_name
    @last_name = contact.last_name
    @spouse_first_name = contact.spouse_first_name
    @spouse_last_name = contact.spouse_last_name
  end

  def envelope
    if full_name_and_spouse_first_name?
      combined_envelope_salutation
    elsif full_name?
      "#{first_name} #{last_name},"
    else
      ""
    end
  end

  def letter
    if both_first_names?
      "Dear #{first_name} & #{spouse_first_name},"
    elsif first_name?
      "Dear #{first_name},"
    else
      ""
    end
  end

  private

  def first_name?
    first_name.present?
  end

  def last_name?
    last_name.present?
  end

  def spouse_first_name?
    spouse_first_name.present?
  end

  def spouse_last_name?
    spouse_last_name.present?
  end

  def full_name?
    first_name? && last_name?
  end

  def spouse_has_blank_or_same_last_name?
    spouse_last_name.blank? || (spouse_last_name == last_name)
  end

  def full_name_and_spouse_first_name?
    full_name? && spouse_first_name?
  end

  def both_first_names?
    first_name? && spouse_first_name?
  end

  def combined_envelope_salutation
    if spouse_has_blank_or_same_last_name?
      "#{first_name} & #{spouse_first_name} #{last_name},"
    else
      "#{first_name} #{last_name} & #{spouse_first_name} #{spouse_last_name},"
    end
  end

end
