release: bundle exec rake heroku_release
web: bundle exec puma -p $PORT -C ./config/puma.rb
worker: bundle exec rake jobs:work
