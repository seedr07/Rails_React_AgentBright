# == Schema Information
#
# Table name: checkouts
#
#  created_at       :datetime         not null
#  id               :integer          not null, primary key
#  plan_id          :integer          not null
#  stripe_coupon_id :string
#  trial            :boolean          default(TRUE), not null
#  updated_at       :datetime         not null
#  user_id          :integer          not null
#
# Indexes
#
#  index_checkouts_on_plan_id           (plan_id)
#  index_checkouts_on_stripe_coupon_id  (stripe_coupon_id)
#  index_checkouts_on_user_id           (user_id)
#
# Foreign Keys
#
#  fk_rails_9bab8f9a32  (user_id => users.id) ON DELETE => cascade
#  fk_rails_ce39b92e84  (plan_id => plans.id) ON DELETE => cascade
#

class Checkout < ActiveRecord::Base

  COMMON_ATTRIBUTES = %i(
    billing_address
    billing_address_2
    billing_city
    billing_country
    billing_organization
    billing_state
    billing_zip_code
    email
    first_name
    last_name
    password
  )

  belongs_to :plan
  belongs_to :user

  validates :user, presence: true

  delegate :includes_team_group?, :name, :sku, :terms, to: :plan, prefix: true
  delegate :email, to: :user, prefix: true

  attr_accessor \
    :stripe_customer_id,
    :stripe_subscription_id,
    :stripe_token,
    :card_last_four_digits,
    :card_type,
    :card_expires_on,
    :trial_ends_at,
    *COMMON_ATTRIBUTES

  def fulfill
    puts "beginning fulfillment..."
    transaction do
      if find_or_create_valid_user
        puts "found or created valid user..."
        puts "creating subscription..."
        create_subscriptions
      end
    end
  end

  def price
    plan.price_in_dollars * quantity
  end

  def quantity
    plan.minimum_quantity
  end

  def coupon
    @coupon ||= Coupon.new(stripe_coupon_id)
  end

  private

  def create_subscriptions
    if create_stripe_subscription && save
      puts "stripe_subscription created and saved..."
      self.stripe_subscription_id = stripe_subscription.id
      self.trial_ends_at = stripe_subscription.trial_ends_at
      update_stripe_customer_id
      plan.fulfill(self, user)
      send_receipt
    end
  end

  def find_or_create_valid_user
    initialize_user

    if user.save
      true
    else
      copy_errors_to_user
      false
    end
  end

  def copy_errors_to_user
    if user.invalid?
      %i(email name password).each do |attribute|
        errors[attribute] = user.errors[attribute]
      end
    end
  end

  def create_stripe_subscription
    stripe_subscription.create
  end

  def initialize_user
    self.user ||= User.new

    AttributesCopier.new(
      source: self,
      target: user,
      attributes: COMMON_ATTRIBUTES
    ).copy_present_attributes
  end

  def update_stripe_customer_id
    user.update(stripe_customer_id: stripe_customer_id)
  end

  def send_receipt
    SendCheckoutReceiptEmailJob.enqueue(id)
  end

  def stripe_subscription
    @stripe_subscription ||= StripeSubscription.new(self)
  end

end
