# frozen_string_literal: true

module Support
  module WithEnv
    # Allows setting temporary ENV variables for a test
    #
    # Usage:
    #
    # with_env("POLLING_INTERVAL" => 1, "EMAIL" => "always") do
    #   .. test here...
    # end
    def with_env(settings)
      old_settings = {}
      settings.each do |variable, value|
        old_settings[variable] = ENV[variable]
        ENV[variable] = value
      end
      yield
    ensure
      settings.each do |variable, _value|
        ENV[variable] = old_settings[variable]
      end
    end
  end
end
