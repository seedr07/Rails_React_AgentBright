# == Schema Information
#
# Table name: phone_numbers
#
#  created_at  :datetime
#  id          :integer          not null, primary key
#  number      :string
#  number_type :string
#  owner_id    :integer
#  owner_type  :string
#  primary     :boolean
#  updated_at  :datetime
#
# Indexes
#
#  index_phone_numbers_on_owner_id_and_owner_type              (owner_id,owner_type)
#  index_phone_numbers_on_owner_id_and_owner_type_and_number   (owner_id,owner_type,number)
#  index_phone_numbers_on_owner_id_and_owner_type_and_primary  (owner_id,owner_type,primary)
#  index_phone_numbers_on_owner_type_and_number                (owner_type,number)
#  phone_numbers_powerful_index                                (owner_id,owner_type,number,primary)
#

class PhoneNumber < ActiveRecord::Base

  default_scope { order("created_at ASC") }

  belongs_to :owner, polymorphic: true, touch: true

  before_save :unset_old_primary_phone_number, if: :primary?
  before_save :set_primary, if: :owner_has_one_phone_number?
  after_save :set_contact_phone_number

  after_commit :delete_phone_if_empty

  def number=(number)
    number = number.gsub(/[\s\-\(\)]+/, "") if number.present?

    self[:number] = number
  end

  private

  def owner_has_one_phone_number?
    return if owner.blank?

    owner_has_one_phone_number_and_record_saved? ||
      owner_has_no_phone_numbers_and_record_not_saved?
  end

  def unset_old_primary_phone_number
    return if owner.blank?

    old_phone_numbers = self.class.where(owner: owner, primary: true)

    unless new_record?
      old_phone_numbers = old_phone_numbers.where("id != ?", id)
    end

    old_phone_numbers.update_all(primary: false)
  end

  def set_primary
    self.primary = true
  end

  def set_contact_phone_number
    if self.owner.is_a?(Contact)
      contact = self.owner
      contact.update_columns(phone_number: contact.primary_phone_number&.number)
    end
  end

  def delete_phone_if_empty
    if number.blank?
      self.delete
    end
  end

  def owner_has_one_phone_number_and_record_saved?
    owner_phone_numbers_count == 1 && !new_record?
  end

  def owner_has_no_phone_numbers_and_record_not_saved?
    owner_phone_numbers_count == 0 && new_record?
  end

  def owner_phone_numbers_count
    @_owner_phone_numbers_count ||= owner.phone_numbers.reload.count
  end

end
