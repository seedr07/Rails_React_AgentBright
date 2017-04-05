# == Schema Information
#
# Table name: failed_api_imports
#
#  created_at :datetime
#  id         :integer          not null, primary key
#  message    :string
#  updated_at :datetime
#  user_id    :integer
#
# Indexes
#
#  index_failed_api_imports_on_user_id  (user_id)
#

class FailedApiImport < ActiveRecord::Base

  belongs_to :user

end
