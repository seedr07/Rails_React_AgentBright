desc "Run scripts when deployed to Heroku"
task heroku_release: [:environment, "db:migrate"] do
  if Rails.env.production?
    puts "[HEROKU_RELEASE.production] Production release complete.\n"
  else
    ["setup_sample_data"].each { |cmd| system "rake #{cmd}" }
    puts "[HEROKU_RELEASE.staging] Staging release complete\n."
  end
end
