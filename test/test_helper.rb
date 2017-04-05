# This has to come first
require_relative "./support/rails"

# Load everything else from test/support
Dir[File.expand_path("../support/**/*.rb", __FILE__)].each { |rb| require(rb) }

class SwitchRailsEnvService

  def switch_env(env)
    old_env, Rails.env = Rails.env, env
    yield
  ensure
    Rails.env = old_env
  end

end

