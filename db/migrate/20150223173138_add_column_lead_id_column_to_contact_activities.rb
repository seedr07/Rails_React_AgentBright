class AddColumnLeadIdColumnToContactActivities < ActiveRecord::Migration
  def change
    add_reference :contact_activities, :lead, index: true
  end
end
