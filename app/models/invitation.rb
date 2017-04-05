# == Schema Information
#
# Table name: invitations
#
#  accepted_at  :datetime
#  code         :string           not null
#  created_at   :datetime         not null
#  email        :string           not null
#  id           :integer          not null, primary key
#  recipient_id :integer
#  sender_id    :integer          not null
#  team_id      :integer          not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_invitations_on_code     (code)
#  index_invitations_on_team_id  (team_id)
#
# Foreign Keys
#
#  fk_rails_37fb5b9295  (team_id => teams.id) ON DELETE => cascade
#

class Invitation < ActiveRecord::Base

  extend FriendlyId

  belongs_to :recipient, class_name: User
  belongs_to :sender, class_name: User
  belongs_to :team_group

  validates :email, presence: true
  validates :sender_id, presence: true
  validates :team_group_id, presence: true

  delegate :name, to: :recipient, prefix: true, allow_nil: true

  before_create :generate_code

  friendly_id :code, use: [:finders]

  def self.pending
    where(accepted_at: nil)
  end

  def deliver
    if save
      InvitationMailer.delay.invitation(id)
      true
    else
      false
    end
  end

  def accept(user)
    transaction do
      update_attributes! accepted_at: Time.zone.now, recipient: user
      team_group.add_user(user)
    end
  end

  def accepted?
    accepted_at.present?
  end

  def sender_name
    sender.name
  end

  def user_by_email
    User.find_by(email: email)
  end

  private

  def generate_code
    self.code = SecureRandom.hex(16)
  end

end
