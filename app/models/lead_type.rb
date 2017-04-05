# == Schema Information
#
# Table name: lead_types
#
#  created_at :datetime
#  id         :integer          not null, primary key
#  name       :string
#  updated_at :datetime
#
# Indexes
#
#  index_lead_types_on_name  (name)
#

class LeadType < ActiveRecord::Base

  has_many :lead_sources, dependent: :destroy
  has_many :leads, dependent: :nullify

  def self.find_or_build_by_name(name)
    where(:name => name).first_or_create
  end

end
