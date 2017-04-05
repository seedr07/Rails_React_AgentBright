# == Schema Information
#
# Table name: activities
#
#  associable_id   :integer
#  associable_type :string
#  created_at      :datetime
#  id              :integer          not null, primary key
#  key             :string
#  owner_id        :integer
#  owner_type      :string
#  parameters      :text
#  recipient_id    :integer
#  recipient_type  :string
#  trackable_id    :integer
#  trackable_type  :string
#  updated_at      :datetime
#
# Indexes
#
#  index_activities_on_associable_type_and_associable_id  (associable_type,associable_id)
#  index_activities_on_owner_id_and_owner_type            (owner_id,owner_type)
#  index_activities_on_recipient_id_and_recipient_type    (recipient_id,recipient_type)
#  index_activities_on_trackable_id_and_trackable_type    (trackable_id,trackable_type)
#

class Activity < ActiveRecord::Base

end
