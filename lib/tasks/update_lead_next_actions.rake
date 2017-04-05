desc "update the next action for each lead"
task :update_lead_next_actions => :environment do
  leads = Lead.all
  leads.each do |lead|
    unless lead.next_action && lead.next_action.completed == false
      Util.log "Lead ID: #{lead.id}"
      Util.log "Lead Name: #{lead.name}"
      if task_with_earliest_due_date = lead.find_next_action
        lead.update_columns(next_action_id: task_with_earliest_due_date.id)
      else
        lead.update_columns(next_action_id: nil)
      end
      Util.log "Next Action: #{lead.next_action.try(:subject) || "None"}"
    end
  end
end
