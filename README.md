[![Build Status](https://travis-ci.org/survival/donation-system.svg?branch=master)](https://travis-ci.org/survival/donation-system)
[![Coverage Status](https://coveralls.io/repos/github/survival/donation-system/badge.svg)](https://coveralls.io/github/survival/donation-system)

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

```bash
bundle install
```

## Tests

You need to set your environment with a `STRIPE_SECRET_KEY` variable equal to a valid Stripe API private test key before running the tests. For example:

```bash
export STRIPE_SECRET_KEY=blah
```

You also need the following Salesforce environment variables:

```bash
export SALESFORCE_HOST='YOUR_SANDBOX'
export SALESFORCE_USERNAME='YOUR_USERNAME'
export SALESFORCE_PASSWORD='YOUR_PASSWORD'
export SALESFORCE_SECURITY_TOKEN='YOUR_SECURITY_TOKEN'
export SALESFORCE_CLIENT_ID='YOUR_CLIENT_ID'
export SALESFORCE_CLIENT_SECRET='YOUR_CLIENT_SECRET'
export SALESFORCE_API_VERSION="38.0"
```

Finally, you need to configure the mailer:

```bash
export EMAIL_SERVER='YOUR_EMAIL_SERVER'
export EMAIL_USERNAME='YOUR_USERNAME'
export EMAIL_PASSWORD='YOUR_PASSWORD'
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

You can send an email to any email address using the `test_email_server.rb` script, and setting your email server, username and password, like this:

```bash
export EMAIL_SERVER='YOUR_EMAIL_SERVER'
export EMAIL_USERNAME='YOUR_USERNAME'
export EMAIL_PASSWORD='YOUR_PASSWORD'
bundle exec ruby scripts/test_email_server.rb 'YOUR_EMAIL_HERE'
```


## Contributing

Please check out our [contribution guides](https://github.com/survival/contributing-guides) and our [code of conduct](https://github.com/survival/contributing-guides/blob/master/code-of-conduct.md)


## License

[![License](https://img.shields.io/badge/mit-license-green.svg?style=flat)](https://opensource.org/licenses/mit)
MIT License
