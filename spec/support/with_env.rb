# frozen_string_literal: true

module Support
  module WithEnv
    def with_env(settings)
      old_settings = {}
      settings.each do |variable, value|
        old_settings[variable] = ENV[variable]
        ENV[variable] = value
      end
      yield
    ensure
      settings.each_key do |variable|
        ENV[variable] = old_settings[variable]
      end
    end
  end
end
