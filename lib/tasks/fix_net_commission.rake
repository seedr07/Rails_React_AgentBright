desc "Fix net commissions not calculating"
task fix_net_commission: :environment do
  Lead.open_clients_and_leads.each do |lead|
    Util.log "\n\nUpdating Lead #{lead.id}: #{lead.name}"
    LeadUpdateDisplayedFieldsService.new(lead).update_all
  end
end
