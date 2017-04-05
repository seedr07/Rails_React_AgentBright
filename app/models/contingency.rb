# == Schema Information
#
# Table name: contingencies
#
#  contract_id :integer
#  created_at  :datetime
#  id          :integer          not null, primary key
#  name        :string
#  status      :string
#  updated_at  :datetime
#
# Indexes
#
#  index_contingencies_on_contract_id  (contract_id)
#

class Contingency < ActiveRecord::Base

  belongs_to :contract

  scope :has_contingency, -> { where("contingency_count > 0") }
  scope :no_contingency, -> { where("contingency_count = 0") }

  scope :contingency_by_status, ->(status) { where("status = ?", status) }
end
