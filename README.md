[![Build Status](https://travis-ci.org/survival/donation-system.svg?branch=master)](https://travis-ci.org/survival/donation-system)
[![Coverage Status](https://coveralls.io/repos/github/survival/donation-system/badge.svg)](https://coveralls.io/github/survival/donation-system)
[![Dependency Status](https://gemnasium.com/badges/github.com/survival/donation-system.svg)](https://gemnasium.com/github.com/survival/donation-system)


# Donation System

This is the new donation system for the Survival International site.


## Installation

This gem is still under development and in an unstable state.
Hence, it is not in rubygems yet.

To use it, add this line to your application's Gemfile:

```ruby
gem 'donation-system', git: 'https://github.com/survival/donation-system'
```

and append `bundle exec` in front of any CLI command that requires this gem.


# Development

To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version. Then push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).


## To initialise the project

You need to have `git` and `bundler` installed.

Run the setup script (**Beware:** Needs permissions to access the credentials repo):

```
. scripts/setup.sh
```

This script will:
* download the credentials
* run the credentials to set the environment
* run `bundle install` to install gems.
* run `bundle exec rake` to run the tests.


## Tests

You need to set your environment by running the credentials. These will be run when you run the `setup.sh` script, but in any case before running the tests ensure that you remember to do:

```
. credentials/.env_test
. credentials/.email_server
```


### To run all tests and rubocop

```bash
bundle exec rake
```


### To run one file


```bash
bundle exec rspec path/to/test/file.rb && rubocop
```


### To run one test

```bash
bundle exec rspec path/to/test/file.rb:TESTLINENUMBER && rubocop
```


## Testing emails in production

You can send an email to any email address using the `test_email_server.rb` script, and making sure that you set your environment with an email server, username and password, by running the credentials:

```bash
. credentials/.email_server
bundle exec ruby scripts/test_email_server.rb 'YOUR_EMAIL_HERE'
```


## Contributing

Please check out our [contribution guides](https://github.com/survival/contributing-guides) and our [code of conduct](https://github.com/survival/contributing-guides/blob/master/code-of-conduct.md)


## License

[![License](https://img.shields.io/badge/mit-license-green.svg?style=flat)](https://opensource.org/licenses/mit)
MIT License
