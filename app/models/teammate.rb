# == Schema Information
#
# Table name: teammates
#
#  created_at :datetime
#  id         :integer          not null, primary key
#  status     :string
#  team_id    :integer
#  updated_at :datetime
#  user_id    :integer
#
# Indexes
#
#  index_teammates_on_user_id_and_team_id  (user_id,team_id) UNIQUE
#

class Teammate < ActiveRecord::Base

  STATUSES = ["invited", "teammate", "rejected"].freeze

  belongs_to :team
  belongs_to :user

  before_create :init_status

  def self.approved
    where(status: "teammate")
  end

  def self.pending_request
    where(status: "invited")
  end

  def confirm_teammates
    team_owner = self.team.owner
    self.user.team_owned.users << team_owner

    user_as_a_teammate = Teammate.find_by(user: team_owner, team: self.user.team_owned)
    user_as_a_teammate.set_teammate_status
    self.set_teammate_status
  end

  def set_teammate_status
    self.status = "teammate"
    save!
  end

  private

  def init_status
    self.status = "invited"
  end

end
