# == Schema Information
#
# Table name: comments
#
#  commentable_id   :integer
#  commentable_type :string
#  content          :text
#  created_at       :datetime
#  id               :integer          not null, primary key
#  updated_at       :datetime
#  user_id          :integer
#
# Indexes
#
#  index_comments_on_commentable_id_and_commentable_type  (commentable_id,commentable_type)
#  index_comments_on_user_id                              (user_id)
#

class Comment < ActiveRecord::Base

  belongs_to :commentable, polymorphic: true
  belongs_to :user

  scope :created_or_updated_within_date_range, -> (starttime, endtime) { where "(created_at >= ? AND created_at <= ?) OR (updated_at >= ? AND updated_at <= ?)", starttime, endtime, starttime, endtime }
  scope :created_within_date_range, -> (starttime, endtime) { where "(created_at >= ? AND created_at <= ?) ", starttime, endtime }
  scope :updated_within_date_range, -> (starttime, endtime) { where "(updated_at >= ? AND updated_at <= ?)", starttime, endtime }

  include PublicActivity::Model
  tracked owner: proc { |controller, _| controller.current_user if controller },
          recipient: proc { |_, comment| comment.commentable },
          params: {
              changes: :changes,
              name: :content
          },
          on: { update: proc { |model, _| model.changes.keys != ['updated_at'] } }

  def created_at_format
    self.created_at.nil? ? " " : created_at.to_s(:date_time)
  end

end
