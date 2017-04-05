# == Schema Information
#
# Table name: media
#
#  created_at :datetime
#  id         :integer          not null, primary key
#  media_type :string
#  num_order  :integer
#  updated_at :datetime
#

class Media < ActiveRecord::Base

  has_many :mktcampaigns

end
