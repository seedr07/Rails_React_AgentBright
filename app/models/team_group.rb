# == Schema Information
#
# Table name: team_groups
#
#  created_at      :datetime         not null
#  id              :integer          not null, primary key
#  name            :string           not null
#  subscription_id :integer          not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_team_groups_on_subscription_id  (subscription_id)
#
# Foreign Keys
#
#  fk_rails_d74bcace70  (subscription_id => subscriptions.id) ON DELETE => cascade
#

class TeamGroup < ActiveRecord::Base

  belongs_to :subscription

  has_many :users, dependent: :nullify
  has_many :invitations, dependent: :destroy

  validates :name, presence: true

  delegate :owner?, :plan, to: :subscription

  def owner
    subscription.user
  end

  def add_user(user)
    user.deactivate_personal_subscription
    user.team_group = self
    user.save!
    update_billing_quantity
    fulfillment_for(user).fulfill
  end

  def remove_user(user)
    user.team_group = nil
    user.save!
    update_billing_quantity
    fulfillment_for(user).remove
  end

  def below_minimum_users?
    users_count < plan.minimum_quantify
  end

  def users_count
    users.count
  end

  def annualized_savings
    users_count * plan.annualized_savings
  end

  private

  def update_billing_quantity
    subscription.change_quantity(billing_quantity)
  end

  def billing_quantity
    [users_count, plan.minimum_quantify].max
  end

  def fulfillment_for(user)
    SubscriptionFulfillment.new(user, plan)
  end

end
