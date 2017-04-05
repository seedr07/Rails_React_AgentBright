# == Schema Information
#
# Table name: plans
#
#  active              :boolean          default(TRUE), not null
#  annual              :boolean          default(FALSE)
#  annual_plan_id      :integer
#  created_at          :datetime
#  description         :text             not null
#  featured            :boolean          default(FALSE), not null
#  id                  :integer          not null, primary key
#  includes_team_group :boolean          default(FALSE), not null
#  interval            :string           default("month"), not null
#  minimum_quantity    :integer          default(1), not null
#  name                :string           not null
#  price_in_dollars    :integer          not null
#  short_description   :string           not null
#  sku                 :string           not null
#  terms               :text
#  updated_at          :datetime
#
# Indexes
#
#  index_plans_on_annual_plan_id  (annual_plan_id)
#

class Plan < ActiveRecord::Base

  DISCOUNTED_ANNUAL_PLAN_SKU = "annual-790".freeze
  LITE_PLAN_SKU = "lite".freeze
  STANDARD_PLAN_SKU = "standard".freeze
  PROFESSIONAL_PLAN_SKU = "professional".freeze

  has_many :checkouts
  has_many :subscriptions
  belongs_to :annual_plan, class_name: "Plan"

  validates :description, presence: true
  validates :price_in_dollars, presence: true
  validates :name, presence: true
  validates :short_description, presence: true
  validates :sku, presence: true

  include PlanForPublicListing

  def self.individual
    where includes_team_group: false
  end

  def self.team_group
    where includes_team_group: true
  end

  def self.active
    where active: true
  end

  def self.default
    individual.active.featured.ordered.first
  end

  def self.default_team_group
    team_group.active.featured.ordered.first
  end

  def self.discounted_annual
    where(sku: DISCOUNTED_ANNUAL_PLAN_SKU).first
  end

  def self.basic
    where(sku: LITE_PLAN_SKU).first
  end

  def self.popular
    where(sku: STANDARD_PLAN_SKU).first
  end

  def popular?
    self == self.class.popular
  end

  def subscription_interval
    stripe_plan.interval
  end

  def fulfill(checkout, user)
    user.create_subscription(
      plan: self,
      stripe_id: checkout.stripe_subscription_id,
      card_last_four_digits: checkout.card_last_four_digits,
      card_type: checkout.card_type,
      card_expires_on: checkout.card_expires_on,
      trial_ends_at: checkout.trial_ends_at
    )
    SubscriptionFulfillment.new(user, self).fulfill
    if includes_team_group?
      TeamGroupFulfillment.new(checkout, user).fulfill
    end
  end

  def included_in_plan?(plan)
    false
  end

  def has_annual_plan?
    annual_plan.present?
  end

  def has_feature?(feature)
    public_send("includes_#{feature}?")
  end

  def annualized_payment
    12 * price_in_dollars
  end

  def discounted_annual_payment
    annual_plan.price_in_dollars
  end

  def annualized_savings
    annualized_payment - discounted_annual_payment
  end

  def annual_plan_sku
    annual_plan.sku
  end

  private

  def stripe_plan
    @stripe_plan ||= Stripe::Plan.retrieve(sku)
  end

end
