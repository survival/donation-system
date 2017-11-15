# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'donation_system/version'

Gem::Specification.new do |spec|
  spec.name        = 'donation_system'
  spec.version     = DonationSystem::VERSION
  spec.author      = %(Survival's web team)
  spec.email       = 'open-source@survivalinternational.org'

  spec.summary     = %(Survival International's donation system)
  spec.description = %(This gem was created to provide the core logic
                       to handle donations to Survival, and it is
                       consumed by the web app)
  spec.homepage    = 'https://github.com/survival/donation-system'
  spec.license     = 'MIT'

  files              = `git ls-files -z`.split("\x0")
  spec.files         = files.reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.test_files    = files.grep(%r{^spec})
  spec.require_paths = ['lib']

  spec.add_dependency 'mail', '~> 2.7', '>= 2.7.0'
  spec.add_dependency 'money', '~> 6.10', '>= 6.10.0'
  spec.add_dependency 'restforce', '~> 2.5.3'
  spec.add_dependency 'stripe', '~> 3.8', '>= 3.8.0'

  spec.add_development_dependency 'coveralls', '~> 0.8', '>= 0.8.21'
  spec.add_development_dependency 'pry', '~> 0.10', '>= 0.10.4'
  spec.add_development_dependency 'rake', '~> 12.0', '>= 12.0.0'
  spec.add_development_dependency 'rspec', '~> 3.6', '>= 3.6.0'
  spec.add_development_dependency 'rubocop', '~> 0.49', '>= 0.49.1'
  spec.add_development_dependency 'vcr', '~> 3.0', '>= 3.0.3'
  spec.add_development_dependency 'webmock', '~> 3.0', '>= 3.0.1'
end
