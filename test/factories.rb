FactoryGirl.define do

  sequence :code do |n|
    "code#{n}"
  end

  sequence :email do |n|
    "user#{n}@example.com"
  end

  sequence :first_name do |n|
    "firstname#{n}"
  end

  sequence :last_name do |n|
    "lastname#{n}"
  end

  factory :plan do
    name I18n.t("shared.subscription.name")
    price_in_dollars 75
    sku "standard"
    short_description "A great Subscription"
    description "A long description"

    factory :lite_plan do
      sku Plan::LITE_PLAN_SKU
    end
  end

  factory :checkout do
    association :plan
    association :user
  end

  factory :user do
    email
    first_name
    last_name
    password "welcome5"

    transient do
      subscription nil
    end

    factory :subscriber do
      with_subscription
    end

    factory :super_admin do
      super_admin true
      with_subscription
    end

    trait :with_stripe do
      stripe_customer_id "cus12345"
    end

    trait :with_subscription do
      stripe_customer_id "cus12345"

      transient do
        plan { create(:plan) }
      end

      after :create do |instance, attributes|
        instance.subscriptions << create(
          :subscription,
          plan: attributes.plan,
          user: instance
        )
      end
    end

    trait :with_full_subscription do
      with_subscription

      transient do
        plan do
          create(:plan)
        end
      end
    end

    trait :with_inactive_subscription do
      stripe_customer_id "cus12345"

      after :create do |instance|
        instance.subscriptions <<
          create(:inactive_subscription, user: instance)
      end
    end

    trait :with_nylas_account do
      nylas_token "Rs5GhEm8mULTVFU3LbPVPGLvPMy2Ma"
      nylas_connected_email_account "jane.jones.agentbright@gmail.com"
    end
  end

  factory :subscription, aliases: [:active_subscription] do
    association :plan
    association :user

    factory :inactive_subscription do
      deactivated_on { Time.zone.today }
    end

    trait :purchased do
      after :create do |subscription|
        create(
          :checkout,
          plan: subscription.plan,
          user: subscription.user
        )
      end
    end
  end

  factory :contact do
    association :user, factory: :subscriber
    first_name
    last_name
    created_by_user { user }
  end

  factory :lead do
    association :user, factory: :subscriber
    association :contact
    status 0
    client_type "Buyer"
    incoming_lead_at Time.current
    state "new_lead"
    contacted_status 0
    created_by_user { user }
  end

  factory :task do
    association :user
    assigned_to { user }
    subject "Thing I need to do"

    factory :completed_task do
      completed true
      completed_at Time.current - 1.day
      completed_by { user }
    end

    factory :incomplete_task do
      completed false
    end

    trait :due_today do
      due_date_at Time.current
    end

    trait :due_yesterday do
      due_date_at Time.current - 1.day
    end

    trait :due_tomorrow do
      due_date_at Time.current + 1.day
    end
  end

end
