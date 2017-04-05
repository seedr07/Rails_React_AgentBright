desc "notifies New Relic of an application deployment"
task notify_new_relic: :environment do
  system "newrelic deployments -u 'Instapusher'"
end
