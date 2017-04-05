# == Schema Information
#
# Table name: api_responses
#
#  api_called_at :datetime
#  api_type      :string
#  created_at    :datetime
#  id            :integer          not null, primary key
#  message       :string
#  status        :string
#  updated_at    :datetime
#
# Indexes
#
#  index_api_responses_on_api_type    (api_type)
#  index_api_responses_on_created_at  (created_at)
#

class ApiResponse < ActiveRecord::Base

end
