desc "Send recurring emails to users"
namespace :send_email do

  task daily_overall_recap: :environment do
     User.send_all_daily_overall_recap_emails
  end

end
