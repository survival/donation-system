[![Build Status](https://travis-ci.org/survival/donation-system.svg?branch=master)](https://travis-ci.org/survival/donation-system)
[![Coverage Status](https://coveralls.io/repos/github/survival/donation-system/badge.svg)](https://coveralls.io/github/survival/donation-system)

# Readme

Explain your project here.


## How to use this project

* If your project is public and hosted in GitHub, you can use travis and coveralls for free.
* If your project is private, you can host it for free in Gitlab and use their CI. You will need to pay for test coverage though.
* Update badges with your user/repo names. Turn your repo ON in Travis.
* Update license to your preferred one.


### To initialise the project

```bash
bundle install
```

## Tests

You need to set your environment with a `STRIPE_API_KEY` variable equal to a valid Stripe API private test key before running the tests. For example:

```bash
export STRIPE_API_KEY=blah
```

### To run all tests and rubocop

```bash
bundle exec rake
```


### To run one file


```bash
bundle exec rspec path/to/test/file.rb
```


### To run one test

```bash
bundle exec rspec path/to/test/file.rb:TESTLINENUMBER
```


## License

[![License](https://img.shields.io/badge/mit-license-green.svg?style=flat)](https://opensource.org/licenses/mit)
MIT License
