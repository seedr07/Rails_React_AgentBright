require "minitest/reporters"

reporter_options = { color: true, slow_count: 10 }

Minitest::Reporters.use!(
  Minitest::Reporters::DefaultReporter.new(reporter_options),
  ENV,
  Minitest.backtrace_filter
)
