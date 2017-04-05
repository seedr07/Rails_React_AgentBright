require "test_helper"
require "stripe_mock"
class StripeApiServiceTest < ActiveSupport::TestCase
  # def setup
  #   @stripe_helper = StripeMock.create_test_helper
  #   StripeMock.start
  # end

  # def teardown
  #   StripeMock.stop
  # end

  # def test_create_card_token
  #   card_token = StripeMock.generate_card_token(last4: "1919", exp_year: 2020)
  #   customer = Stripe::Customer.create(card: card_token)
  #   card = customer.cards.data.first
  #   assert_equal card.last4, "1919"
  #   assert_equal card.exp_year, 2020
  # end

  # def test_receive_card_error
  #   StripeMock.prepare_card_error(:card_declined)
  #   Stripe::Charge.create
  #   rescue Stripe::CardError => e
  #     assert_equal e.http_status, 402
  #     assert_equal e.code, "card_declined"
  # end

  # def test_create_plan
  #   plan = @stripe_helper.create_plan(id: "test_plan", amount: 15000)
  #   assert_equal plan.id, "test_plan"
  #   assert_equal plan.amount, 15000
  # end

  # def test_create_customer
  #   customer = Stripe::Customer.create(email: "john@example.com",
  #                                      card: @stripe_helper.generate_card_token)
  #   assert_equal customer.email, "john@example.com"
  # end

  # def test_create_subscription
  #   _plan = @stripe_helper.create_plan(id: "test_plan", amount: 15000)
  #   customer = Stripe::Customer.create(email: "john@example.com",
  #                                      card: @stripe_helper.generate_card_token)
  #   subscription = customer.subscriptions.create(plan: "test_plan")
  #   assert_equal subscription.plan.id, "test_plan"
  # end

  # def test_update_plan
  #   _plan = @stripe_helper.create_plan(id: "test_plan", amount: 15000)
  #   updated_plan = Stripe::Plan.retrieve("test_plan")
  #   updated_plan.name = "updated_test"
  #   updated_plan.save
  #   assert_equal updated_plan.name, "updated_test"
  # end

  # def test_update_customer
  #   customer = Stripe::Customer.create(email: "john@example.com",
  #                                      card: @stripe_helper.generate_card_token)
  #   updated_customer = Stripe::Customer.retrieve(customer.id)
  #   updated_customer.description = "Customer for test@example.com"
  #   updated_customer.save
  #   assert_equal updated_customer.description, "Customer for test@example.com"
  # end

  # def test_update_subscription
  #   _plan = @stripe_helper.create_plan(id: "test_plan", amount: 15000)
  #   _plan2 = @stripe_helper.create_plan(id: "test_plan2", amount: 25000)
  #   customer = Stripe::Customer.create(email: "john@example.com",
  #                                      card: @stripe_helper.generate_card_token)
  #   subscription = customer.subscriptions.create(plan: "test_plan")
  #   updated_subscription = customer.subscriptions.retrieve(subscription.id)
  #   updated_subscription.plan = "test_plan2"
  #   updated_subscription.save
  #   assert_equal updated_subscription.plan.id, "test_plan2"
  # end
end
