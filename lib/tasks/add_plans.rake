desc "adds plans to database"
task add_plans: :environment do
  Plan.transaction do
    @lite_plan = create_plan(
      sku: "lite",
      name: "Lite Plan",
      price_in_dollars: 29,
      short_description: "The plan to get you started on a budget.",
      description: "A long description.",
      featured: true
    )

    @standard_plan = create_plan(
      sku: "standard",
      name: "Standard Plan",
      price_in_dollars: 79,
      short_description: "The that gives you the best bang for your buck.",
      description: "A long description.",
      featured: true
    )

    @professional_plan = create_plan(
      sku: "professional",
      name: "Professional Plan",
      price_in_dollars: 129,
      short_description: "Enjoy every feature at your disposal.",
      description: "A long description.",
      featured: true
    )

    @discounted_annual_plan = create_plan(
      sku: Plan::DISCOUNTED_ANNUAL_PLAN_SKU,
      name: "Discounted Annual Plan",
      price_in_dollars: 790,
      short_description: "Everything you're used to, but a bit cheaper.",
      description: "A long description.",
      featured: false,
      annual: true
    )

    @free_plan = create_plan(
      sku: "free",
      name: "Free Plan",
      price_in_dollars: 0,
      short_description: "Totally free plan.",
      description: "A long description.",
      featured: false
    )
  end
end

def create_plan(options={})
  Plan.create! options
end
