if ENV["CODECLIMATE_REPO_TOKEN"]
  require "codeclimate-test-reporter"
  CodeClimate::TestReporter.start
end

if ENV["CIRCLE_ARTIFACTS"]
  require "simplecov"
  dir = File.join("..", "..", "..", "..", ENV["CIRCLE_ARTIFACTS"], "coverage")
  SimpleCov.coverage_dir(dir)
end

require "simplecov"

SimpleCov.start do
  add_filter "/test/"
  add_filter "/config/"
  add_filter "/ctmls_scraper/"

  add_group "Models", "app/models"
  add_group "Controllers", "app/controllers"
  add_group "Services", "app/services"
  add_group "Helpers", "app/helpers"
  add_group "Mailers", "app/mailers"
  add_group "Workers", "app/workers"
  add_group "Jobs", "app/jobs"
  add_group "Carriers", "app/carriers"
  add_group "Uploaders", "app/uploaders"
  add_group "Email Parsing", ["app/email_matchers", "app/email_parsers"]
end

ENV["RAILS_ENV"] ||= "test"
require File.expand_path("../../../config/environment", __FILE__)
require "rails/test_help"
require "timecop"
require "rake/testtask"
require "webmock/minitest"

DatabaseCleaner.strategy = :truncation

class ActiveSupport::TestCase

  ActiveRecord::Migration.check_pending!
  fixtures :all
  include FactoryGirl::Syntax::Methods

end
