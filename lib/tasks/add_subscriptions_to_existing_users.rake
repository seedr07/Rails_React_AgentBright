desc "add subscription to free plan to all users who don't have a subscription"
task add_subscriptions_to_existing_users: :environment do
  @free_plan = Plan.find_by(sku: "free")

  User.all.each do |user|
    if user.subscriptions.empty?
      checkout = @free_plan.checkouts.build(
        user: user,
        email: user.email
      )

      puts "creating checkout for #{user.email}"
      checkout.fulfill
    end
  end
end
