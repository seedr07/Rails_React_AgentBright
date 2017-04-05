source "https://rubygems.org"

ruby "2.3.1"

gem "rails", "5.0.0.1"

gem "pg", "0.18.4" # postgresql database

gem "active_median", "~> 0.1.0" # used with chartkick for graph reporting
gem "activerecord-session_store", require: false # save session to database
gem "acts-as-taggable-on", git: "https://github.com/mbleigh/acts-as-taggable-on" # tagging
gem "administrate", git: "https://github.com/heyogrady/administrate", branch: "rails5"
gem "analytics-ruby", "~> 2.0.0", require: "segment/analytics" # segment.io
gem "arel"
gem "autoprefixer-rails" # for CSS vendor prefixes
gem "bootbox-rails", "~>0.4" # wrappers for javascript dialogs
gem "bootstrap-switch-rails" # bootstrap-switch.js
gem "bourbon"
gem "bower-rails" # install front-end components
gem "browser" # For variants support
gem "carrierwave" # for handling file uploads
gem "carmen-rails" # country and region selection
gem "chartkick"
gem "chronic" # natural language date parser
gem "codemirror-rails", ">= 5.11" # display source code in pattern library
gem "coffee-rails", ">= 4.1.1"
gem "coffee-script-source", ">= 1.8.0" # Coffee script source
gem "country_select" # HTML list of countries
gem "dalli" # for memcached
gem "delayed_job_active_record", ">= 4.1" # background job processing
gem "delayed_job_web", ">= 1.2.10" # web interface for delayed job
gem "devise", ">= 4.2.0"
gem "devise-async", git: "https://github.com/mhfs/devise-async", branch: "devise-4.x" # for user authentication
gem "flamegraph" # super pretty flame graphs
gem "fog", require: false # for handling s3
# gem "font_assets" # Handle Cross-Origin Resource Sharing on fonts
gem "font_assets", git: "https://github.com/ericallam/font_assets", ref: "457dcfddc4318e83679e9a0935612924b7717085"
gem "friendly_id", "~> 5.1.0"
gem "fullcontact" # social profile info from fullcontact.com
gem "fuzzy_match" # used by smart_csv_parser for contact & address mapping
gem "google-api-client", "< 0.9", require: "google/api_client" # connecting to Google API
gem "groupdate" # used with chartkick for graph reporting
gem "handy", git: "https://github.com/heyogrady/handy"
gem "hike" # finds files in a set of paths
gem "honeybadger" # for error tracking
gem "inky-rb", require: "inky", git: "https://github.com/zurb/inky-rb", branch: "develop" # for email templates
gem "intercom-rails" # tracking user behavior
gem "introjs-rails" # for onboarding coaching and instructions
gem "jbuilder", ">= 2.4.1" # for building JSON
gem "jquery-fileupload-rails", "~> 0.4.6" # file uploads
gem "jquery-rails" # jQuery
gem "jquery-ui-rails" # jQuery UI
gem "json" # for parsing JSON
gem "kaminari" # pagination
gem "le" # logentries
gem "listen"
gem "lograge" # better log formatting
gem "mandrill-api", require: "mandrill" # sending and tracking emails
gem "mechanize" # for screen scraping
gem "memory_profiler" # lets us use rack-mini-profilers GC features
gem "mini_magick" # processing images
gem 'mini_racer', platforms: :ruby
gem "newrelic_rpm" # monitor app performance
gem "nylas", "~> 2.0" # emails, calendar, contacts via Nylas.com
gem "oink"
gem "omniauth" # third party authentication
gem "omniauth-google-oauth2" # Google authentication
gem "omnicontacts" # retrieve contacts from email providers
gem "open_uri_redirections" # allow OpenURI redirections from HTTP to HTTPS
gem "paper_trail" # maintain record of stripe plans & subscriptions
gem "prawn-labels" # PDF labels
gem 'premailer-rails' # Stylesheet inlining for email
gem 'premailer'
gem "puma" # server
gem "public_activity" # for model activity tracking
gem "rack-mini-profiler", require: false # display page load time badge
gem "rails-deprecated_sanitizer" # Our app uses old sanitizer methods.
gem "rails-html-sanitizer"
gem "react_on_rails", "~> 6.3.2"
gem "responders", "~> 2.0" # respond_with and respond_to methods
gem "rest-client"
gem "sass-rails", ">= 5.0.3"
gem "semantic-ui-sass", git: "https://github.com/heyogrady/semantic-ui-sass"
gem "select2-rails", "3.5.10" # select/search/dropdown box
gem "selenium-webdriver", require: false # screen-scraping
gem "signet"
gem "simple_form", ">= 3.2.1" # forms made easy for rails
gem "sinatra", git: "https://github.com/sinatra/sinatra"
gem "stripe", "~> 1.15.0" # charging customers
gem "stripe_event" # Stripe webhook integration
gem "stackprof" # a stack profiler
gem "state_machines-activemodel", ">= 0.4.0.pre"
gem "state_machines-activerecord", ">= 0.4.0.pre"
gem "toastr-rails" # display toaster notifications
gem "turbolinks", "~> 5.0.0.beta" # faster page loads
gem "twilio-ruby" # phone and SMS services
gem "twitter-typeahead-rails", "~> 0.11.1.pre.corejavascript" # typeahead.js - autocomplete
gem "uglifier", ">= 1.0.3"
gem "uuidtools"
gem "valid_email" # email validation
gem "wicked" # multi-page wizard forms
gem "yaml_db", git: "https://github.com/heyogrady/yaml_db", branch: "monkey-patch-rails-5" # import/export yml->db
gem "yaml_dump", git: "https://github.com/vanboom/yaml_dump" # dump db records to yaml files
# gem "zeroclipboard-rails", "~> 0.1.1" # copy to clipboard
gem "rails_autolink"
gem "activerecord-import", require: false
gem "carrierwave_direct"
gem "nokogiri"
gem "httparty", require: false # HTTP interaction.
gem "hashie", require: false

group :development do
  gem "annotate" # auto generate schema documentation
  gem "better_errors" # better rails error messages
  gem "binding_of_caller" # interactive console in browser on errors
  gem "bullet" # notify of db queries that can be improved
  gem "guard", "~> 2.13.0"
  gem "guard-livereload", "~> 2.5.2", require: false # changed files = autoreloaded browser
  gem "guard-minitest", "~> 2.4.4" # automatically run tests
  gem "guard-rubocop", "~> 1.2.0" # use rubocop with guard
  gem "meta_request" # for usings RailsPanel Chrome extension
  # gem "quiet_assets" # mutes assets pipeline log messages
  gem "rubocop" # evaluate against style guide
  gem "shog" # colored log output
  gem "spring" # speeds up development by keeping app running in the background
  gem "xray-rails", ">= 0.1.18" # inspect view partials in the browser
  gem "web-console", "~> 3.0" # for debugging via in-browser IRB consoles
end

group :test do
  gem "codeclimate-test-reporter", require: nil # CodeClimate test coverage
  gem "database_cleaner" # database cleaner for testing
  gem "factory_girl_rails" # for setting up ruby objects as test data
  gem "minitest-around" # acceptance testing with browser automation
  gem "minitest-ci", git: "https://github.com/circleci/minitest-ci"
  gem "minitest-reporters", require: false # custom MiniTest output formats
  gem "mocha", require: false # mocking and stubbing library
  # gem "rails-controller-testing" # for additional controller testing features
  gem "ruby-prof"
  gem "simplecov", require: false # for test coverage report
  gem "stripe-ruby-mock", "~> 2.0.0", require: "stripe_mock"
  # gem "test_after_commit"
  gem "timecop", require: false # simulate time in tests
  gem "vcr" # record and reuse external HTTP requests to speed up testing
  gem "webmock" # goes with VCR
end

group :development, :test do
  gem "awesome_print" # pretty print Ruby objects with style
  gem "byebug" # for interactively debugging behavior
  if !ENV["CI"]
    gem "ruby_gntp" # send notifications to Growl
  end
  gem "dotenv-rails" # Shim to load environment variables from .env into ENV in development.
  gem "jazz_fingers", ">= 3.0.2" # pry-based enhancements
  gem "pry-rails" # for interactively exploring objects
  gem "rails-erd" # for visualizing the schema
end

group :staging, :production, :beta, :acceptance do
  gem "rack-timeout" # raise error if Puma doesn't respond in given time
  gem "rails_12factor" # better logging
  gem "rails_stdout_logging"
end


# Until the API calls are out of beta, you must manually specify my fork
# of the Heroku API gem:
# gem "platform-api", git: "https://github.com/jalada/platform-api", branch: "master"
# gem "letsencrypt-rails-heroku", group: "production"

# Memory profiling
# gem "derailed_benchmarks"


