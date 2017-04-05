# == Schema Information
#
# Table name: cursors
#
#  created_at  :datetime         not null
#  cursor_id   :string
#  data        :text
#  event       :string
#  id          :integer          not null, primary key
#  object_id   :string
#  object_type :text             default(""), not null
#  updated_at  :datetime         not null
#  user_id     :integer
#
# Indexes
#
#  index_cursors_on_cursor_id    (cursor_id)
#  index_cursors_on_event        (event)
#  index_cursors_on_object_id    (object_id)
#  index_cursors_on_object_type  (object_type)
#  index_cursors_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_a0c6942e89  (user_id => users.id) ON DELETE => cascade
#

class Cursor < ActiveRecord::Base

  belongs_to :user

end
