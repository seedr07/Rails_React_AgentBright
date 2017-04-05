require 'bundler'
Bundler.setup

require 'derailed_benchmarks'
require 'derailed_benchmarks/tasks'

namespace :perf do
  task :rack_load do
    require_relative 'lib/application'
  end
end

DerailedBenchmarks.auth.user = -> { User.find_by(email: "john@example.com") }
