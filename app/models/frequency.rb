# == Schema Information
#
# Table name: frequencies
#
#  created_at :datetime
#  freq_order :integer
#  freq_type  :string
#  id         :integer          not null, primary key
#  updated_at :datetime
#

class Frequency < ActiveRecord::Base

   has_many :mktcampaigns

end
