# == Schema Information
#
# Table name: teams
#
#  created_at :datetime
#  id         :integer          not null, primary key
#  updated_at :datetime
#  user_id    :integer
#
# Indexes
#
#  index_teams_on_user_id  (user_id)
#

class Team < ActiveRecord::Base

  belongs_to :owner, class_name: "User", inverse_of: :team_owned, foreign_key: "user_id"
  has_many :teammates, dependent: :destroy
  has_many :users, through: :teammates

  def self.add_teammate(user_email, team_owner)
    @new_teammate = User.find_by(email: user_email.to_s.strip)
    @user = team_owner

    if new_teammate_not_found?
      "Agent with email #{user_email} not found!"
    elsif already_teammates?
      "Agent #{@new_teammate.full_name} is already part of your team."
    elsif new_teammate_same_as_user?
      "You can't add yourself as your teammate."
    elsif new_teammate_has_already_confirmed_user?
      confirm_new_teammate
      "#{@new_teammate.full_name} and you are now teammates."
    else
      invite_new_teammate_to_join_team
      "Invited agent #{@new_teammate.full_name} to join your team."
    end
  end

  def self.remove_teammate(user_id, team_owner)
    if user_to_remove = User.find_by(id: user_id)
      team_owner.team_owned.users.delete(user_to_remove)
      user_to_remove.team_owned.users.delete(team_owner)
    end
  end

  def approved_teammates
    user_ids = teammates.approved.pluck(:user_id).uniq
    User.where(id: user_ids)
  end

  private

  def self.new_teammate_not_found?
    @new_teammate.blank?
  end

  def self.already_teammates?
    @user.team_owned.users.include?(@new_teammate)
  end

  def self.new_teammate_same_as_user?
    @user == @new_teammate
  end

  def self.team_owned_by_new_teammate
    @new_teammate.try(:team_owned)
  end

  def self.new_teammate_has_already_confirmed_user?
    team_owned_by_new_teammate && team_owned_by_new_teammate.users.include?(@user)
  end

  def self.confirm_new_teammate
    teammate = Teammate.find_by(team: team_owned_by_new_teammate, user: @user)
    teammate.confirm_teammates
  end

  def self.invite_new_teammate_to_join_team
    @user.team_owned.users << @new_teammate
    send_invite
  end

  def self.send_invite
    Mailer.delay.invite_user_to_join_team(@user.id, @new_teammate.id)
  end

end
