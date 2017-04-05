desc "find account id for nylas token and save"
task populate_nylas_account_id: :environment do
  User.where("nylas_token is not null").each do |user|
    token = user.nylas_token
    account_id = NylasApi::Account.new(token).account_id
    if account_id
      puts "[NYLAS] Saving #{user.name}'s account id: (#{account_id})"
      user.update(nylas_account_id: account_id)
    end
  end
end
