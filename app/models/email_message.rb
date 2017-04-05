# == Schema Information
#
# Table name: email_messages
#
#  account            :string
#  bcc                :string
#  body               :text
#  cc                 :string
#  created_at         :datetime         not null
#  from_email         :string
#  from_name          :string
#  id                 :integer          not null, primary key
#  message_id         :string
#  received_at        :datetime
#  snippet            :string
#  subject            :string
#  thread_id          :string
#  to                 :string
#  to_email_addresses :string           default([]), is an Array
#  unread             :boolean
#  updated_at         :datetime         not null
#  user_id            :integer
#
# Indexes
#
#  index_email_messages_on_account     (account)
#  index_email_messages_on_from_email  (from_email)
#  index_email_messages_on_message_id  (message_id)
#  index_email_messages_on_thread_id   (thread_id)
#  index_email_messages_on_user_id     (user_id)
#

class EmailMessage < ActiveRecord::Base

  belongs_to :user

end
