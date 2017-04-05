# == Schema Information
#
# Table name: contracts
#
#  additional_fees                  :decimal(, )
#  broker_commission_custom         :boolean          default(FALSE)
#  broker_commission_fee            :decimal(, )
#  broker_commission_percentage     :decimal(, )
#  broker_commission_type           :string
#  buyer                            :string
#  buyer_agent                      :string
#  closing_date_at                  :datetime
#  closing_price                    :decimal(, )
#  commission_fee_buyer_side        :decimal(, )
#  commission_fee_total             :decimal(, )
#  commission_flat_fee              :decimal(, )
#  commission_percentage_buyer_side :decimal(, )
#  commission_percentage_total      :decimal(, )
#  commission_rate                  :decimal(, )
#  commission_type                  :string
#  contract_type                    :string
#  created_at                       :datetime
#  id                               :integer          not null, primary key
#  lead_id                          :integer
#  offer_accepted_date_at           :datetime
#  offer_deadline_at                :datetime
#  offer_price                      :decimal(, )
#  property_id                      :integer
#  referral_fee_flat_fee            :decimal(, )
#  referral_fee_rate                :decimal(, )
#  referral_fee_type                :string
#  seller                           :string
#  seller_agent                     :string
#  status                           :string
#  updated_at                       :datetime
#
# Indexes
#
#  index_contracts_on_lead_id      (lead_id)
#  index_contracts_on_property_id  (property_id)
#  index_contracts_on_status       (status)
#

class Contract < ActiveRecord::Base

  STATUSES = {
    pending_contingencies: "Pending contingencies",
    ready_to_close: "Ready to close",
    closed: "Closed",
    fell_through: "Fell through"
  }.freeze

  include ActivityWatcher
  include PublicActivity::Model
  include RecentActivity

  tracked(
    owner: proc { |controller, _| controller.current_user if controller },
    recipient: proc { |_, contract| contract.lead },
    params: { changes: :activity_parameters_changes, name: :activity_info },
    on: { update: proc { |model, _| model.savable_activity?(model.activity_parameters_changes) } }
  )

  recent_activities_for(
    self: {
      attributes: [
        :additional_fees,
        :buyer,
        :buyer_agent,
        :closing_date_at,
        :closing_price,
        :commission_flat_fee,
        :commission_rate,
        :offer_accepted_date_at,
        :offer_deadline_at,
        :offer_price,
        :referral_fee_flat_fee,
        :referral_fee_rate,
        :status,
        :seller,
        :seller_agent,
      ]
    },
    associations: { contingencies: { attributes: [:name, :status] } }
  )

  belongs_to :lead, touch: true
  belongs_to :property, counter_cache: true, touch: true
  has_many :contingencies, dependent: :destroy

  accepts_nested_attributes_for :contingencies, allow_destroy: true

  validates :offer_price, presence: { message: "Contract must have a price" }

  before_destroy :reset_property_status
  before_destroy :reset_lead_status

  scope :open, -> { where(status: ["pending_contingencies", "ready_to_close", "closed"]) }
  scope :past, -> { where(status: ["fell_through"]) }
  scope :accepted, -> { where(status: ["pending_contingencies", "ready_to_close", "closed"]) }


  def accepted_status?
    status == "pending_contingencies" || status == "ready_to_close" || status == "closed"
  end

  def open_status?
    status == "pending_contingencies" || status == "ready_to_close" || status == "closed"
  end

  def update_lead_referral_fees
    self.referral_fee_flat_fee = nil if self.referral_fee_type == "Percentage"
    self.referral_fee_rate = nil if self.referral_fee_type == "Fee"

    lead.update_columns(
      additional_fees: additional_fees,
      referral_fee_type: referral_fee_type,
      referral_fee_rate: referral_fee_rate,
      referral_fee_flat_fee: referral_fee_flat_fee
    )
    lead.touch
  end

  def update_property_status
    return if property.nil?

    if property.transaction_type == "Buyer"
      update_buyer_property_status
    elsif property.lead.client_type == "Seller"
      update_seller_property_status
    end
  end

  def reset_lead_status
    if accepted_status? && lead && (3..4).cover?(lead.status)
      self.lead.update!(status: 2)
    end
  end

  def reset_property_status
    return if property.nil?

    if property.transaction_type == "Buyer"
      self.property.update!(level_of_interest: "Interested")
    end
  end

  def update_lead_displayed_values
    LeadUpdateDisplayedFieldsService.new(self.lead).update_all
  end

  def update_closing_price
    self.closing_price = status == "closed" ? self.offer_price : nil
  end

  def status_to_s
    STATUSES[status.to_sym]
  end

  private

  def activity_info
    price = ActionController::Base.helpers.number_to_currency(offer_price, precision: 0)
    "#{price} offer on #{self.property.try(:name)}"
  end

  def update_buyer_property_status
    case status
    when "pending_contingencies" || "ready_to_close"
      update_property_level_of_interest("Under Contract")
      update_lead_status(3)
    when "closed"
      update_property_level_of_interest("Closed")
      update_lead_status(4)
    when "fell_through"
      update_property_level_of_interest("Contract Cancelled")
      update_lead_status(2)
    end
  end

  def update_seller_property_status
    case status
    when "pending_contingencies" || "ready_to_close"
      update_lead_status(3)
    when "closed"
      update_lead_status(4)
    when "fell_through"
      update_lead_status(2)
    end
  end

  def update_lead_status(status)
    lead.update_columns(status: status)
    lead.touch
  end

  def update_property_level_of_interest(level_of_interest)
    property.update_columns(level_of_interest: level_of_interest)
    property.touch
  end

end
