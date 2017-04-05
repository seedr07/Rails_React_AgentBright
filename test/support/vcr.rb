require "vcr"

VCR.configure do |c|
  c.hook_into :webmock
  c.cassette_library_dir = "test/vcr_cassettes"
  c.default_cassette_options = { record: :new_episodes, allow_playback_repeats: true }
  # c.debug_logger = STDOUT
  c.allow_http_connections_when_no_cassette = true
end
