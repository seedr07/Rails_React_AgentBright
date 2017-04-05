# == Schema Information
#
# Table name: authorizations
#
#  access_token             :string
#  created_at               :datetime
#  email                    :string
#  expires_in               :integer
#  first_name               :string
#  id                       :integer          not null, primary key
#  last_name                :string
#  link                     :string
#  name                     :string
#  provider                 :string
#  refresh_expires          :boolean
#  refresh_token            :string
#  refresh_token_expires_at :datetime
#  secret                   :string
#  token                    :string
#  uid                      :string
#  updated_at               :datetime
#  user_id                  :integer
#  via_inbox_app            :boolean          default(FALSE)
#
# Indexes
#
#  index_authorizations_on_provider  (provider)
#  index_authorizations_on_uid       (uid)
#  index_authorizations_on_user_id   (user_id)
#

class Authorization < ActiveRecord::Base

  belongs_to :user

  scope :google, -> { where("provider = ?", "Google") }
  scope :inbox, -> { where("provider = ?", "Inbox") }

end
