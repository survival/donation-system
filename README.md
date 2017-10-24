[![Build Status](https://travis-ci.org/survival/donation-system.svg?branch=master)](https://travis-ci.org/survival/donation-system)
[![Coverage Status](https://coveralls.io/repos/github/survival/donation-system/badge.svg)](https://coveralls.io/github/survival/donation-system)

# Readme

This is the new donation system for the Survival International site.


### To initialise the project

```bash
bundle install
```

## Tests

You need to set your environment with a `STRIPE_API_KEY` variable equal to a valid Stripe API private test key before running the tests. For example:

```bash
export STRIPE_API_KEY=blah
```

You also need the following Salesforce environment variables:

```bash
export SALESFORCE_USERNAME='YOUR_USERNAME'
export SALESFORCE_PASSWORD='YOUR_PASSWORD'
export SALESFORCE_SECURITY_TOKEN='YOUR_SECURITY_TOKEN'
export SALESFORCE_CLIENT_ID='YOUR_CLIENT_ID'
export SALESFORCE_CLIENT_SECRET='YOUR_CLIENT_SECRET'
export SALESFORCE_API_VERSION="38.0"
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


## License

[![License](https://img.shields.io/badge/mit-license-green.svg?style=flat)](https://opensource.org/licenses/mit)
MIT License
