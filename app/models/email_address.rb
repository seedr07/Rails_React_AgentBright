# == Schema Information
#
# Table name: email_addresses
#
#  created_at :datetime
#  email      :string
#  email_type :string
#  id         :integer          not null, primary key
#  owner_id   :integer
#  owner_type :string
#  primary    :boolean
#  updated_at :datetime
#
# Indexes
#
#  email_addresses_powerful_index                                (owner_id,owner_type,email,primary)
#  index_email_addresses_on_email                                (email)
#  index_email_addresses_on_email_type                           (email_type)
#  index_email_addresses_on_owner_id_and_owner_type              (owner_id,owner_type)
#  index_email_addresses_on_owner_id_and_owner_type_and_email    (owner_id,owner_type,email)
#  index_email_addresses_on_owner_id_and_owner_type_and_primary  (owner_id,owner_type,primary)
#  index_email_addresses_on_owner_type_and_email_and_primary     (owner_type,email,primary)
#  index_email_addresses_on_primary                              (primary)
#

class EmailAddress < ActiveRecord::Base
  default_scope { order("created_at ASC") }

  belongs_to :owner, polymorphic: true, touch: true

  validates_format_of :email, :with => /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/, allow_blank: true, message: "Please enter a valid email address"
  # validate :required_information

  before_save :unset_old_primary_email_address, if: :primary?
  before_save :set_primary, if: :owner_has_one_email_address?
  after_save :set_contact_email

  after_commit :delete_email_if_empty

  def self.owner_from_email(email)
    email_address = find_by_email email
    email_address.owner if email_address.present?
  end

  def required_information
    unless self.public_send(:email).present?
      errors.add(:required_information, ' not sufficient')
    end
  end

  private

  def owner_has_one_email_address?
    return if owner.blank?

    (owner_email_addresses_count == 1 && !new_record?) ||
      (owner_email_addresses_count == 0 && new_record?)
  end

  def unset_old_primary_email_address
    return if owner.blank?

    old_addresses = self.class.where(owner: owner, primary: true)

    unless new_record?
      old_addresses = old_addresses.where("id != ?", id)
    end

    old_addresses.update_all(primary: false)
  end

  def set_primary
    self.primary = true
  end

  def set_contact_email
    if self.owner.is_a?(Contact)
      contact = self.owner
      contact.update_columns(email: contact.primary_email_address&.email)
    end
  end

  def delete_email_if_empty
    if email.blank?
      self.delete
    end
  end

  def owner_email_addresses_count
    @_owner_email_addresses_count ||= owner.email_addresses.reload.count
  end
end
