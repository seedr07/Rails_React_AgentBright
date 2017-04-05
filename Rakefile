# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require "rake/testtask"
require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

# Adding test/email_parsers directory to the rake test.
namespace :test do
  desc "Test email_parsers code"
  Rake::TestTask.new(email_parsers: 'test:prepare') do |t|
    t.pattern = 'test/email_parsers/**/*_test.rb'
  end
end

# Adding test/email_matchers directory to the rake test.
namespace :test do
  desc "Test email_matchers code"
  Rake::TestTask.new(email_matchers: 'test:prepare') do |t|
    t.pattern = 'test/email_matchers/**/*_test.rb'
  end
end

Rake::Task['test:run'].enhance ["test:email_parsers", "test:email_matchers"]
