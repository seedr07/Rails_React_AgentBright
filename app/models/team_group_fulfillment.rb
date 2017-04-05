class TeamGroupFulfillment

  def initialize(checkout, user)
    @checkout = checkout
    @user = user
  end

  def fulfill
    @user.team_group = create_team_group
    @user.save!
  end

  private

  def create_team_group
    TeamGroup.create!(
      name: generate_team_group_name,
      subscription: subscription
    )
  end

  def generate_team_group_name
    @user.email.sub(/^.*@/, "").split(".")[-2].titleize
  end

  def subscription
    @user.subscription
  end

end
