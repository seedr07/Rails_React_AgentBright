# == Schema Information
#
# Table name: lead_sources
#
#  created_at   :datetime
#  id           :integer          not null, primary key
#  lead_type_id :integer
#  name         :string
#  updated_at   :datetime
#
# Indexes
#
#  index_lead_sources_on_lead_type_id  (lead_type_id)
#  index_lead_sources_on_name          (name)
#

class LeadSource < ActiveRecord::Base

  belongs_to :lead_type
  has_many :leads, dependent: :nullify

end
