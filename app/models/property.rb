# == Schema Information
#
# Table name: properties
#
#  additional_fees                  :decimal(, )
#  bathrooms                        :decimal(, )
#  bedrooms                         :integer
#  commission_fee                   :decimal(, )
#  commission_fee_buyer_side        :decimal(, )
#  commission_fee_total             :decimal(, )
#  commission_percentage            :decimal(, )
#  commission_percentage_buyer_side :decimal(, )
#  commission_percentage_total      :decimal(, )
#  commission_type                  :string
#  contracts_count                  :integer          default(0)
#  created_at                       :datetime
#  id                               :integer          not null, primary key
#  initial_agent_valuation          :decimal(, )
#  initial_client_valuation         :decimal(, )
#  initial_property_interested_in   :boolean          default(FALSE)
#  lead_id                          :integer
#  level_of_interest                :string
#  list_price                       :decimal(, )
#  listing_expires_at               :datetime
#  lot_size                         :decimal(, )
#  mls_number                       :string
#  notes                            :text
#  original_list_date_at            :datetime
#  original_list_price              :decimal(, )
#  property_type                    :integer
#  property_url                     :string
#  referral_fee_flat_fee            :decimal(, )
#  referral_fee_rate                :decimal(, )
#  referral_fee_type                :string
#  referral_fees                    :decimal(, )
#  rental                           :boolean
#  sq_feet                          :integer
#  transaction_type                 :string
#  updated_at                       :datetime
#  user_id                          :integer
#
# Indexes
#
#  index_properties_on_lead_id           (lead_id)
#  index_properties_on_transaction_type  (transaction_type)
#  index_properties_on_user_id           (user_id)
#

class Property < ActiveRecord::Base

  PROPERTY_TYPES = [
    ["Single Family", 0],
    ["Multi-family", 1],
    ["Condo", 2],
    ["Apartment", 3],
    ["Office/Commercial", 4],
    ["Land", 5],
  ].freeze

  include ActivityWatcher
  include PublicActivity::Model
  include RecentActivity

  tracked owner: proc { |controller, _| controller.current_user if controller },
          recipient: proc { |_, property| property.lead },
          params: {
            changes: :activity_parameters_changes,
            name: :one_line_address
          },
          on: {
            update: proc do |model, _|
              model.savable_activity?(model.activity_parameters_changes)
            end
          }

  recent_activities_for self: { attributes: [:list_price, :mls_number, :property_url,
                                             :rental, :original_list_date_at,
                                             :original_list_price, :listing_expires_at,
                                             :commission_percentage, :commission_fee,
                                             :initial_client_valuation, :initial_agent_valuation,
                                             :bedrooms, :bathrooms, :sq_feet, :lot_size, :notes,
                                             :property_type, :transaction_type, :level_of_interest,
                                             :referral_fee_rate, :referral_fee_flat_fee] },
                        associations: { address: { attributes: [:street, :city, :state, :zip] } }

  attr_accessor :trackable_lead_activity

  belongs_to :lead, inverse_of: :properties, touch: true
  belongs_to :user
  has_many :contracts, dependent: :destroy
  has_many :images
  has_one :address, as: :owner, dependent: :destroy
  has_one :property_image, as: :attachable, class_name: "Image", dependent: :destroy

  accepts_nested_attributes_for :property_image
  accepts_nested_attributes_for :address

  after_create :call_property_api
  after_save :update_contract_status
  after_save :set_original_listing_details

  scope :active, -> {
    where(level_of_interest: ["Possible", "Interested", "Under Contract", nil])
  }
  scope :archived, -> {
    where(level_of_interest: ["Not Interested", "Not Available", "Contract Cancelled", "Contract Rejected"])
  }
  scope :buyer_properties, -> { where(transaction_type: "Buyer") }
  scope :has_accepted_contract, -> {
    where("level_of_interest in ('Under Contract','Closed') AND contracts_count > 0")
  }
  scope :has_contract, -> { where("contracts_count > 0") }
  scope :no_contract, -> { where("contracts_count == 0") }
  scope :not_under_contract_and_active, -> {
    where("level_of_interest NOT in('Under Contract', 'Closed', 'Not Interested', 'Not Available')")
  }
  scope :under_contract, -> {
    where("level_of_interest in ('Under Contract', 'Closed', 'Contract Cancelled')")
  }

  def self.call_api(id)
    options = { property_id: id }
    PropertyApiResearchService.new(options).call_api
  end

  def name
    one_line_address
  end

  def address_details
    address.city_state_zip if address
  end

  def one_line_address
    address.one_line if address
  end

  def property_address
    address
  end

  def full_address
    address.full_address
  end

  def property_type_to_s
    Property::PROPERTY_TYPES[property_type][0] if property_type.present?
  end

  def has_buyer_contract?
    contracts.present?
  end

  def has_accepted_buyer_contract?
    contracts.accepted.present?
  end

  def buyer_contract
    contracts.first if has_buyer_contract?
  end

  def call_property_api
    Property.delay.call_api(self.id)
  end

  def property_image_url
    if property_image
      property_image.file.url
    else
      "https://placehold.it/180"
    end
  end

  def has_image?
    property_image.present? && property_image.file.present?
  end

  private

  def set_original_listing_details
    if transaction_type == "Seller"
      lead = self.lead
      lead.original_list_date_at = original_list_date_at
      lead.original_list_price = original_list_price

      if self.trackable_lead_activity && self.trackable_lead_activity.to_s == "false"
        lead.trackable_activity = false
      end
      lead.save!
    end
  end

  def update_contract_status
    if has_buyer_contract? && transaction_type == "Buyer" && self.changed.include?("level_of_interest")
      case level_of_interest
      when "Closed"
        update_buyer_contract_status("closed")
        update_lead_status(4)
      when "Under Contract"
        update_buyer_contract_status("pending_contingencies")
        update_lead_status(3)
      when "Contract Cancelled"
        update_buyer_contract_status("fell_through")
      when "Contract Rejected"
        update_buyer_contract_status("fell_through")
        update_lead_status(2)
      end
    end
  end

  def update_buyer_contract_status(status)
    buyer_contract.update_columns(status: status)
    buyer_contract.touch
  end

  def update_lead_status(status)
    lead.update_columns(status: status)
    lead.touch
  end

end
